//
//  TodoListViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import Moya_ModelMapper
import Mapper

typealias TodoListSection = SectionModel<String, TodoModel>

protocol TodoListViewModelType {
    // view was dealocated
    var viewDidDeallocate: PublishSubject<Void> { get }

    // User selected an item in the tableview
    var itemDidSelect: PublishSubject<TodoModel> { get }
    var itemDeleted: PublishSubject<IndexPath> { get }
    var addButtonItemDidTap: PublishSubject<Void> { get }

    // sections which power the tableview
    var sections: Driver<[TodoListSection]> { get }

    var isRefreshing: Driver<Bool> { get }

    // Fetch todos from the server
    func loadTodos()
}

struct TodoListViewModel: TodoListViewModelType {
    fileprivate let disposeBag = DisposeBag()
    fileprivate let appCoordinator: AppCoordinator
    fileprivate var todos = Variable<[TodoModel]>([TodoModel]())

    var isLoading = Variable<Bool>(false)

    let viewDidLoad = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()
    let todoService: RxMoyaProvider<TodoService>
    var sections: Driver<[TodoListSection]>
    let itemDidSelect = PublishSubject<TodoModel>()
    let itemDeleted = PublishSubject<IndexPath>()
    let addButtonItemDidTap = PublishSubject<Void>()
    let isRefreshing: Driver<Bool>

    init(todoService: RxMoyaProvider<TodoService>, appCoordinator: AppCoordinator) {
        self.todoService = todoService
        self.appCoordinator = appCoordinator

        addButtonItemDidTap
            .takeUntil(viewDidDeallocate)
            .subscribe(onNext: {
                appCoordinator.addTodo()
            })
            .addDisposableTo(disposeBag)

        itemDeleted
            .takeUntil(viewDidDeallocate)
            .withLatestFrom(todos.asObservable(), resultSelector: { (indexPath, todos) -> TodoModel in
                let tastedBeers = todos.filter { $0.isDone }
                let untastedBeers = todos.filter { !$0.isDone }
                let group = indexPath.section == 0 ? untastedBeers : tastedBeers

                return group[indexPath.row]
            })
            .flatMapLatest({ todo -> Observable<Response> in
                return todoService.request(.deleteTodo(id: todo.id))
                    .debug("delete toto")
            })
            .subscribe({ event in
                switch event {
                case .next:
                    appCoordinator.viewTodos()
                case .error(let error):
                    _ = error
                // show error?
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)

        itemDidSelect
            .takeUntil(viewDidDeallocate)
            .flatMapLatest({ todo -> Observable<Response> in
                let doneTodo = TodoModel(id: todo.id,
                                         title: todo.title,
                                         description: todo.description,
                                         isDone: !todo.isDone)
                return todoService.request(.updateTodo(todo: doneTodo))
                    .debug()
            })
            .mapObject(type: TodoModel.self)
            .subscribe({ event in
                switch event {
                case .next:
                    appCoordinator.viewTodos()
                case .error(let error):
                    _ = error
                // show error?
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)

        sections = todos
            .asObservable()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { todos in
                let tastedBeers = todos.filter { $0.isDone }
                let untastedBeers = todos.filter { !$0.isDone }
                let tastedSection = TodoListSection(model: "tasted", items: tastedBeers)
                let untastedSection = TodoListSection(model: "untasted", items: untastedBeers)

                return .just([untastedSection, tastedSection])
            }

        isRefreshing = isLoading
            .asObservable()
            .asDriver(onErrorJustReturn: false)
    }

    func loadTodos() {
        isLoading.value = true
        todoService.request(.fetchAll)
            .debug()
            .mapArray(type: TodoModel.self)
            .subscribe(onNext: { todos in
                self.isLoading.value = false
                self.todos.value = todos
            })
            .addDisposableTo(disposeBag)

    }
}
