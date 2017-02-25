//
//  TodoCellViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TodoCellViewModelType {
    var title: String { get }
    var titleColor: UIColor { get }
    var accessoryType: UITableViewCellAccessoryType { get }
}

struct TodoCellViewModel: TodoCellViewModelType {

    let title: String
    let titleColor: UIColor
    let accessoryType: UITableViewCellAccessoryType

    init(todo: TodoModel) {
        self.title = todo.title
        self.titleColor = todo.isDone ? .lightGray : .black
        self.accessoryType = todo.isDone ? .checkmark : .none
    }
}
