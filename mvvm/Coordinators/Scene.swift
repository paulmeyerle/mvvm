//
//  Scene.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/25/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation

enum Scene {
    case viewTodos(viewModel: TodoListViewModelType)
    case addTodo(viewModel: AddTodoViewModelType)
}
