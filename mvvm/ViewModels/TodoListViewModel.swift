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
    var viewDidLoad: PublishSubject<Void> { get }
    var viewDidDeallocate: PublishSubject<Void> { get }
    var sections: Driver<[TodoListSection]> { get }
    var itemDidSelect: PublishSubject<TodoModel> { get }
    var addButtonItemDidTap: PublishSubject<Void> { get }
}

struct TodoListViewModel:TodoListViewModelType {
    fileprivate let disposeBag = DisposeBag()
    fileprivate let appCoordinator: AppCoordinator
    
    let viewDidLoad = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()
    let todoService: RxMoyaProvider<TodoService>
    let sections: Driver<[TodoListSection]>
    let itemDidSelect = PublishSubject<TodoModel>()
    let addButtonItemDidTap = PublishSubject<Void>()
    
    init(todoService: RxMoyaProvider<TodoService>, appCoordinator: AppCoordinator) {
        self.todoService = todoService
        self.appCoordinator = appCoordinator
        
        let tasks: Observable<[TodoModel]> = self.todoService.request(.fetchAll)
            .debug("fetch tasks")
            .mapArray(type: TodoModel.self)
        
        self.sections = tasks
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { todos in
                // convert the todo models into a section for the tableview
                let section = TodoListSection(model: "title", items: todos)
                return .just([section])
            }
        
        self.addButtonItemDidTap
            .takeUntil(self.viewDidDeallocate)
            .subscribe(onNext: {
                appCoordinator.addTodo()
            })
            .addDisposableTo(disposeBag)
        
        self.itemDidSelect
            .takeUntil(self.viewDidDeallocate)
            .subscribe(onNext: { model in
                appCoordinator.viewTodo(todo: model)
            })
            .addDisposableTo(self.disposeBag)
    }
}
