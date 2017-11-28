//
//  sceneCoordinator.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import UIKit
import Then
import Moya

class SceneCoordinator: SceneCoordinatorType {
    let navigationController: UINavigationController
    let networking: NetworkProvider

    init(navigationController: UINavigationController, networking: NetworkProvider) {
        self.navigationController = navigationController
        self.networking = networking
    }

    public func transition(scene: SceneType, type: SceneTransitionType) {
        // first we need to get the view controller
        let viewController = buildViewController(scene: scene)

        switch type {
        case .root:
            navigationController.viewControllers = [viewController]
        case .push:
            navigationController.pushViewController(viewController, animated: true)
        case .modal:
            navigationController.present(viewController, animated: true, completion: {
                // completion
            })
        }
    }

    public func pop() {
        guard let currentViewController = navigationController.visibleViewController else {
            return
        }

        if let presenter = currentViewController.presentingViewController {
            presenter.dismiss(animated: true, completion: {
                // completion
            })
        } else {
            navigationController.popViewController(animated: true)
        }
    }

    private func buildViewController(scene: SceneType) -> UIViewController {
        switch scene {
        case .addTodo(let viewModel):
            return AddTodoItemViewController(viewModel: viewModel)
        case .viewTodos(let viewModel):
            return TodoListViewController(viewModel: viewModel)
        }
    }

    public func start() {
        let viewModel = TodoListViewModel(networking: networking, sceneCoordinator: self)
        transition(scene: SceneType.viewTodos(viewModel: viewModel), type: .root)
    }
}
