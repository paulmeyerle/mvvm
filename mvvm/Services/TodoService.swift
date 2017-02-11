//
//  TodoService.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol TaskServiceType {
    func fetchAll() -> Observable<[TodoModel]>
}

struct TodoService: TaskServiceType {
    func fetchAll() -> Observable<[TodoModel]> {
        
        let fakeData = [
            TodoModel(title: "one", description: "description 1"),
            TodoModel(title: "two", description: "description 2"),
            TodoModel(title: "three", description: "description 3"),
            TodoModel(title: "four", description: "description 4"),
        ]
        
        return .just(fakeData)
    }
}
