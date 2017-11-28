//
//  TodoListViewModelType.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/26/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TodoListViewModelType {
    // Inputs
    var viewDidAppear: PublishSubject<Bool> { get }
    var addButtonItemDidTap: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<TodoItemCellViewModel> { get }
    var itemDeleted: PublishSubject<IndexPath> { get }
    var reloadTodos: PublishSubject<Void> { get }

    // Outputs
    var isLoading: Driver<Bool> { get }
    var isRefreshing: Driver<Bool> { get }
    var sections: Driver<[TodoListSection]> { get }
    var titleText: Driver<String> { get }
}
