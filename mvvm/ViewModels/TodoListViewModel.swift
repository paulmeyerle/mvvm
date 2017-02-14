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
    //
    var addButtonItemDidTap: PublishSubject<Void> { get }
    
    // sections which power the tableview
    var sections: Driver<[TodoListSection]> { get }
    
    var isRefreshing: Driver<Bool> { get }
    
    // Fetch todos from the server
    func loadTodos()
}

struct TodoListViewModel:TodoListViewModelType {
    fileprivate let disposeBag = DisposeBag()
    fileprivate let appCoordinator: AppCoordinator
    fileprivate var todos = Variable<[TodoModel]>([TodoModel]())
    
    var isLoading = Variable<Bool>(false)
    
    let viewDidLoad = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()
    let todoService: RxMoyaProvider<TodoService>
    var sections: Driver<[TodoListSection]>
    let itemDidSelect = PublishSubject<TodoModel>()
    let addButtonItemDidTap = PublishSubject<Void>()
    let isRefreshing: Driver<Bool>
    
    init(todoService: RxMoyaProvider<TodoService>, appCoordinator: AppCoordinator) {
        self.todoService = todoService
        self.appCoordinator = appCoordinator
        
        self.addButtonItemDidTap
            .takeUntil(self.viewDidDeallocate)
            .subscribe(onNext: {
                appCoordinator.addTodo()
            })
            .addDisposableTo(disposeBag)
        
        self.itemDidSelect
            .takeUntil(self.viewDidDeallocate)
            .subscribe(onNext: { todo in
                appCoordinator.viewTodo(todo: todo)
            })
            .addDisposableTo(self.disposeBag)
        
        self.sections = self.todos
            .asObservable()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { todos in
                let section = TodoListSection(model: "title", items: todos)
                return .just([section])
            }
        
        self.isRefreshing = self.isLoading
            .asObservable()
            .asDriver(onErrorJustReturn: false)
    }
    
    func loadTodos() {
        self.isLoading.value = true
        self.todoService.request(.fetchAll)
            .debug()
            .mapArray(type: TodoModel.self)
            .subscribe(onNext: { todos in
                self.isLoading.value = false
                self.todos.value = todos
            })
            .addDisposableTo(self.disposeBag)
        
    }
}
