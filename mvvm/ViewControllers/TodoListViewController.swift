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
import RxCocoa
import RxDataSources

class TodoListViewController: BaseViewController {

    let refreshControl = UIRefreshControl()

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

        navigationItem.title = "Beer Wishlist"
        navigationItem.rightBarButtonItem = addButtonItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        configure()
        refreshData()
    }

    private func setupLayout() {
        refreshControl.addTarget(self, action: #selector(TodoListViewController.refreshData), for: .valueChanged)

        tableview.addSubview(refreshControl)
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    private func configure() {
        // Bind View Model
        dataSource.configureCell = { _, tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell else {
                return UITableViewCell()
            }
            let cellViewModel = TodoCellViewModel(todo: viewModel) as TodoCellViewModelType
            cell.configure(viewModel: cellViewModel)
            return cell
        }

        dataSource.canEditRowAtIndexPath = { _ in
            return true
        }

        viewModel.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)

        viewModel.sections
            .drive(tableview.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        addButtonItem.rx.tap
            .bindTo(viewModel.addButtonItemDidTap)
            .addDisposableTo(disposeBag)

        rx.deallocated
            .bindTo(viewModel.viewDidDeallocate)
            .addDisposableTo(disposeBag)

        tableview.rx.modelSelected(TodoModel.self)
            .bindTo(viewModel.itemDidSelect)
            .addDisposableTo(disposeBag)

        tableview.rx.itemDeleted
            .bindTo(viewModel.itemDeleted)
            .addDisposableTo(disposeBag)

    }

    func refreshData() {
        viewModel.loadTodos()
    }
}
