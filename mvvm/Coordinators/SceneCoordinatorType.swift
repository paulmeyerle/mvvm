//
//  Coordinator.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit

protocol SceneCoordinatorType {
    /// Start the first scene for the application
    func start()

    /// Transition to another scene within the application
    func transition(scene: SceneType, type: SceneTransitionType)

    /// Pop the visible view controller from the stack
    func pop()
}
