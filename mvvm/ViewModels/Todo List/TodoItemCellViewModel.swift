//
//  TodoCellViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import RxCocoa
import RxSwift

struct TodoItemCellViewModel: TodoItemCellViewModelType {
    let todo: TodoModel
    let title: String
    let titleColor: UIColor
    let accessoryType: UITableViewCellAccessoryType

    init(todo: TodoModel) {
        self.todo = todo
        title = todo.title
        titleColor = todo.isDone ? .lightGray : .black
        accessoryType = todo.isDone ? .checkmark : .none
    }
}
