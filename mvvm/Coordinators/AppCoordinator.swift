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

    let navigationController: UINavigationController
    let todoService: RxMoyaProvider<TodoService>

    init(navigationController: UINavigationController, todoService: RxMoyaProvider<TodoService>) {
        self.navigationController = navigationController
        self.todoService = todoService

        setup()
    }

    func setup() {
        navigationController.navigationBar.isTranslucent = false
    }

    func start() {
        let viewModel = TodoListViewModel(todoService: todoService, appCoordinator: self)
        let listController = TodoListViewController(viewModel: viewModel)
        navigationController.pushViewController(listController, animated: false)
    }

    func stop() {
        navigationController.popViewController(animated: true)
    }

    func addTodo() {
        let viewModel = AddTodoViewModel(todoService: todoService, appCoordinator: self)
        let viewController = AddTodoItemViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func viewTodos() {
        navigationController.popToRootViewController(animated: true)
        if let viewController = navigationController.topViewController as? TodoListViewController {
            viewController.refreshData()
        }
    }
}
