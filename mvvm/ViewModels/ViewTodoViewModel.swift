//
//  ViewTodoViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ViewTodoViewModelType {
    var title: String { get }
    var description: String { get }
}

struct ViewTodoViewModel: ViewTodoViewModelType {
    
    let title: String
    let description: String
    
    init(todo: TodoModel) {
        self.title = todo.title
        self.description = todo.description
    }
}
