//
//  TodoListViewController.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxDataSources

class TodoListViewController: BaseViewController {
    
    let tableview = UITableView().then {
        $0.register(TodoCell.self, forCellReuseIdentifier: "cell")
        $0.estimatedRowHeight = 50.0
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
    }
    
    let disposeBag = DisposeBag()
    let viewModel: TodoListViewModelType
    let dataSource = RxTableViewSectionedReloadDataSource<TodoListSection>()
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    init(viewModel: TodoListViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Todo Items"
        self.setupLayout()
        self.configure()
    }
    
    private func setupLayout() {
        // Navigation Bar
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        
        // Layout tableview
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view)
        }
    }
    
    private func configure() {
        // Bind View Model
        self.dataSource.configureCell = { _, tableView, indexPath, viewModel in
            let cell: TodoCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoCell
            let cellViewModel = TodoCellViewModel(todo: viewModel) as TodoCellViewModelType
            cell.configure(viewModel: cellViewModel)
            return cell
        }
        self.dataSource.canEditRowAtIndexPath = { _ in true }
        self.dataSource.canMoveRowAtIndexPath = { _ in true }
        
        self.viewModel.sections
            .drive(self.tableview.rx.items(dataSource: self.dataSource))
            .addDisposableTo(self.disposeBag)
        
        self.addButtonItem.rx.tap
            .bindTo(viewModel.addButtonItemDidTap)
            .addDisposableTo(self.disposeBag)
        
        self.rx.deallocated
            .bindTo(viewModel.viewDidDeallocate)
            .addDisposableTo(self.disposeBag)
        
        self.tableview.rx.modelSelected(TodoModel.self)
            .bindTo(viewModel.itemDidSelect)
            .addDisposableTo(self.disposeBag)
    }
}
