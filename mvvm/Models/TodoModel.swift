//
//  TodoModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import Foundation
import Mapper

struct TodoModel: Mappable {
    let id: UInt
    let title: String
    let description: String
    let isDone: Bool

    init(id: UInt = 0, title: String, description: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isDone = isDone
    }

    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        try description = map.from("description")
        try isDone = map.from("isDone")
    }
}
