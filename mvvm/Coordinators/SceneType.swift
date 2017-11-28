//
//  Scene.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/25/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import Foundation

enum SceneType {
    case viewTodos(viewModel: TodoListViewModelType)
    case addTodo(viewModel: AddTodoViewModelType)
}
