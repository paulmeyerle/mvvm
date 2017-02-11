//
//  TodoModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation

struct TodoModel {
    let id: String
    let title: String
    let description: String
    let isDone: Bool
    
    init(title: String, description: String) {
        self.id = UUID.init().uuidString
        self.title = title
        self.description = description
        self.isDone = false
    }
}
