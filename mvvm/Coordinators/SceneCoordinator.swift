//
//  sceneCoordinator.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import Then
import Moya

class SceneCoordinator: SceneCoordinatorType {
    let navigationController: UINavigationController
    let networking: PMNetworking

    init(navigationController: UINavigationController, networking: PMNetworking) {
        self.navigationController = navigationController
        self.networking = networking
    }

    public func transition(scene: Scene, type: SceneTransitionType) {
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

    private func buildViewController(scene: Scene) -> UIViewController {
        switch scene {
        case .addTodo(let viewModel):
            return AddTodoItemViewController(viewModel: viewModel)
        case .viewTodos(let viewModel):
            return TodoListViewController(viewModel: viewModel)
        }
    }

    public func start() {
        let viewModel = TodoListViewModel(networking: networking, sceneCoordinator: self)
        transition(scene: Scene.viewTodos(viewModel: viewModel), type: .root)
    }
}
