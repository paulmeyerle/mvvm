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
    let taskService: TaskServiceType
    let sections: Driver<[TodoListSection]>
    let itemDidSelect = PublishSubject<TodoModel>()
    let addButtonItemDidTap = PublishSubject<Void>()
    
    init(taskService: TaskServiceType, appCoordinator: AppCoordinator) {
        self.taskService = taskService
        self.appCoordinator = appCoordinator
        
        self.sections = self.taskService.fetchAll().map { todoItems in
            let section = TodoListSection(model: "title", items: todoItems)
            return [section]
        }.asDriver(onErrorJustReturn: [])
        
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
