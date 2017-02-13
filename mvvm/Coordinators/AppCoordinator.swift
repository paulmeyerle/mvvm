//
//  AppCoordinator.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import Then
import Moya

class AppCoordinator: CoordinatorType {
    
    let baseViewController = UINavigationController().then {
        $0.navigationBar.isTranslucent = false
    }

    init() {
        let todoService = RxMoyaProvider<TodoService>()
        let viewModel = TodoListViewModel(todoService: todoService, appCoordinator: self)
        let listController = TodoListViewController(viewModel: viewModel)
        self.baseViewController.pushViewController(listController, animated: false)
    }

    func start() {
        // NOOP
    }
    
    func addTodo() {
        let viewModel = AddTodoViewModel()
        let viewController = AddTodoItemViewController(viewModel: viewModel)
        self.baseViewController.pushViewController(viewController, animated: true)
    }
    
    func viewTodo(todo: TodoModel) {
        let viewModel = ViewTodoViewModel(todo: todo)
        let viewController = ViewTodoItemViewController(viewModel: viewModel)
        self.baseViewController.pushViewController(viewController, animated: true)
    }
}
