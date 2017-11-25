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

typealias TodoListSection = SectionModel<String, TodoCellViewModel>

protocol TodoListViewModelType {
    // Inputs
    var viewDidAppear: PublishSubject<Bool> { get }
    var addButtonItemDidTap: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<TodoCellViewModel> { get }
    var itemDeleted: PublishSubject<IndexPath> { get }
    var reloadTodos: PublishSubject<Void> { get }

    // Outputs
    var isLoading: Driver<Bool> { get }
    var isRefreshing: Driver<Bool> { get }
    var sections: Driver<[TodoListSection]> { get }
    var titleText: Driver<String> { get }
}

struct TodoListViewModel: TodoListViewModelType {
    private let disposeBag = DisposeBag()
    private let onUpdateTrigger = PublishSubject<Void>()

    // Inputs
    public let viewDidAppear = PublishSubject<Bool>()
    public let addButtonItemDidTap = PublishSubject<Void>()
    public let itemDidSelect = PublishSubject<TodoCellViewModel>()
    public let itemDeleted = PublishSubject<IndexPath>()
    public let reloadTodos = PublishSubject<Void>()

    // Outputs
    public let isLoading: Driver<Bool>
    public let isRefreshing: Driver<Bool>
    public let sections: Driver<[TodoListSection]>
    public let titleText: Driver<String>

    init(networking: PMNetworking, sceneCoordinator: SceneCoordinator) {
        let fetchObservable = Observable.merge([
            viewDidAppear.map { _ in },
            reloadTodos,
            onUpdateTrigger
            ])
            .shareReplay(1)

        let todosObservable = fetchObservable
            .flatMapLatest { _ in
                return networking.fetchTodos()
            }
            .shareReplay(1)

        isLoading = Observable.merge([
            viewDidAppear.map { _ in true },
            todosObservable.map { _ in false }
            ])
            .asDriver(onErrorJustReturn: false)

        isRefreshing = Observable.merge([
            reloadTodos.map { true },
            todosObservable.map { _ in false }
            ])
            .asDriver(onErrorJustReturn: false)

        titleText = Observable.just("Beer List")
            .asDriver(onErrorJustReturn: "Beer List")

        let sectionsObservable = todosObservable
            .map { todos -> [TodoListSection] in
                let tastedBeers = todos
                    .filter { $0.isDone }
                    .map { TodoCellViewModel(todo: $0) }

                let untastedBeers = todos
                    .filter { !$0.isDone }
                    .map { TodoCellViewModel(todo: $0) }

                let tastedSection = TodoListSection(model: "Sampled", items: tastedBeers)
                let untastedSection = TodoListSection(model: "Wish List", items: untastedBeers)

                return [untastedSection, tastedSection]
            }
            .shareReplay(1)

        sections = sectionsObservable
            .asDriver(onErrorJustReturn: [])

        addButtonItemDidTap
            .subscribe(onNext: {
                let viewModel = AddTodoViewModel(networking: networking, sceneCoordinator: sceneCoordinator)
                let scene = Scene.addTodo(viewModel: viewModel)
                sceneCoordinator.transition(scene: scene, type: .push)
            })
            .addDisposableTo(disposeBag)

        itemDeleted
            .withLatestFrom(sectionsObservable, resultSelector: { (indexPath, sections) -> UInt in
                let sectionTodos = sections[indexPath.section]
                let cellViewModel = sectionTodos.items[indexPath.row]
                return cellViewModel.todo.id
            })
            .flatMapLatest { id -> Observable<Void> in
                return networking.deleteTodo(id: id)
            }
            .subscribe(onNext: { [weak onUpdateTrigger] _ in
                onUpdateTrigger?.onNext(Void())
            })
            .addDisposableTo(disposeBag)

        itemDidSelect
            .flatMapLatest { todoCellViewModel -> Observable<TodoModel> in
                let todo = todoCellViewModel.todo
                let updatedTodo = TodoModel(id: todo.id,
                                            title: todo.title,
                                            description: todo.description,
                                            isDone: !todo.isDone)
                return networking.updateTodo(todo: updatedTodo)
            }
            .subscribe(onNext: { [weak onUpdateTrigger] _ in
                onUpdateTrigger?.onNext(Void())
            })
            .addDisposableTo(disposeBag)
    }
}
