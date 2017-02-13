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
        
        self.sections = self.todoService.request(.fetchAll)
            .debug()
            .mapArrayOptional(type: TodoModel.self)
            .map({ todos in
                guard let todos = todos else {
                    return []
                }
                
                let section = TodoListSection(model: "title", items: todos)
                return [section]
            })
            .asDriver(onErrorJustReturn: [])
        
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
