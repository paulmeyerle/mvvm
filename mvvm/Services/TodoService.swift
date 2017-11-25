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
import Moya

enum TodoService {
    case fetchAll
    case fetchTodo(id: UInt)
    case createTodo(todo: TodoModel)
    case updateTodo(todo: TodoModel)
    case deleteTodo(id: UInt)
}

extension TodoService: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:3000")!
    }

    var path: String {
        switch self {
        case .fetchAll, .createTodo:
            return "/tasks"
        case .fetchTodo(let id):
            return "/tasks/\(id)"
        case .updateTodo(let todo):
            return "/tasks/\(todo.id)"
        case .deleteTodo(let id):
            return "/tasks/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchAll, .fetchTodo:
            return .get
        case .updateTodo:
            return .put
        case .createTodo:
            return .post
        case .deleteTodo:
            return .delete
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .fetchAll, .fetchTodo, .deleteTodo:
            return nil
        case .createTodo(let todo), .updateTodo(let todo):
            return ["title": todo.title, "description": todo.description, "isDone": todo.isDone]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchAll, .fetchTodo, .deleteTodo:
            return URLEncoding.default
        case .createTodo, .updateTodo:
            return JSONEncoding.default
        }
    }

    var sampleData: Data {
        switch self {
        case .fetchAll:
            return "[{\"id\": 1, \"title\": \"Write TODO\", \"description\": \"test description\", \"isDone\": 1}]".data(using: .utf8)!
        case .fetchTodo(let id):
            return "{\"id\": \(id), \"title\": \"Write TODO\", \"description\": \"test description\", \"isDone\": 1}".data(using: .utf8)!
        case .createTodo(let todo):
            return "{\"id\": 100, \"title\": \"\(todo.title)\", \"description\": \"\(todo.description)\", \"isDone\": \(todo.isDone)}".data(using: .utf8)!
        case .updateTodo(let todo):
            return "{\"id\": \(todo.id), \"title\": \"\(todo.title)\", \"description\": \"\(todo.description)\", \"isDone\": \(todo.isDone)}".data(using: .utf8)!
        case .deleteTodo(let id):
            return "{}".data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {
        case .createTodo, .updateTodo, .fetchAll, .fetchTodo, .deleteTodo:
            return .request
        }
    }
}
