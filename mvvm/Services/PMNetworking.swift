//
//  Networking.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/25/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper

struct PMNetworking: PMNetworkingType {
    private let todoService: RxMoyaProvider<TodoService>

    init(todoService: RxMoyaProvider<TodoService>) {
        self.todoService = todoService
    }

    public func fetchTodos() -> Observable<[TodoModel]> {
        return todoService.request(.fetchAll)
            .retry(3)
            .mapArray(type: TodoModel.self)
    }

    public func addTodo(todo: TodoModel) -> Observable<TodoModel> {
        return todoService.request(.createTodo(todo: todo))
            .retry(3)
            .mapObject(type: TodoModel.self)
    }

    public func updateTodo(todo: TodoModel) -> Observable<TodoModel> {
        return todoService.request(.updateTodo(todo: todo))
            .retry(3)
            .mapObject(type: TodoModel.self)
    }

    func deleteTodo(id: UInt) -> Observable<Void> {
        return todoService.request(.deleteTodo(id: id))
            .retry(3)
            .map { _ in }
    }
}
