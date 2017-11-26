//
//  TodoItemCellViewModelType.swift
//  mvvm
//
//  Created by Paul Meyerle on 11/26/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit

protocol TodoItemCellViewModelType {
    var title: String { get }
    var titleColor: UIColor { get }
    var accessoryType: UITableViewCellAccessoryType { get }
}
