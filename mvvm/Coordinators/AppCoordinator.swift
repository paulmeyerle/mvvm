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

        self.setup()
    }

    func setup() {
        self.navigationController.navigationBar.isTranslucent = false
    }

    func start() {
        let viewModel = TodoListViewModel(todoService: self.todoService, appCoordinator: self)
        let listController = TodoListViewController(viewModel: viewModel)
        self.navigationController.pushViewController(listController, animated: false)
    }

    func stop() {
        self.navigationController.popViewController(animated: true)
    }

    func addTodo() {
        let viewModel = AddTodoViewModel(todoService: self.todoService, appCoordinator: self)
        let viewController = AddTodoItemViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func viewTodos() {
        self.navigationController.popToRootViewController(animated: true)
        if let viewController = navigationController.topViewController as? TodoListViewController {
            viewController.refreshData()
        }
    }
}
