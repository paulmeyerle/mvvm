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
    var description: String { get }
    var accessoryType: UITableViewCellAccessoryType { get }
}

struct TodoCellViewModel: TodoCellViewModelType {
    
    let title: String
    let description: String
    let accessoryType: UITableViewCellAccessoryType
    
    init(todo: TodoModel) {
        self.title = todo.title
        self.description = todo.description
        self.accessoryType = todo.isDone ? .checkmark : .none
    }
}
