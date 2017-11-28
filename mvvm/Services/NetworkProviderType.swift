//
//  PMNetworkingType.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/25/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkProviderType {
    func fetchTodos() -> Observable<[TodoModel]>
    func addTodo(todo: TodoModel) -> Observable<TodoModel>
    func updateTodo(todo: TodoModel) -> Observable<TodoModel>
    func deleteTodo(id: UInt) -> Observable<Void>
}
