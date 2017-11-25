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

class TodoListViewController: UIViewController {

    private let refreshControl = UIRefreshControl()

    private let tableview = UITableView().then {
        $0.register(TodoCell.self, forCellReuseIdentifier: "cell")
        $0.estimatedRowHeight = 50.0
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
    }

    private let disposeBag = DisposeBag()

    private let viewModel: TodoListViewModelType

    private let dataSource = RxTableViewSectionedReloadDataSource<TodoListSection>()

    private let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    init(viewModel: TodoListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        configure()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = addButtonItem

        tableview.addSubview(refreshControl)

        tableview.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        view.addSubview(tableview)

        tableview.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    private func configure() {
        addButtonItem.rx.tap
            .bind(to: viewModel.addButtonItemDidTap)
            .addDisposableTo(disposeBag)

        rx.viewDidAppear
            .bind(to: viewModel.viewDidAppear)
            .addDisposableTo(disposeBag)

        tableview.rx.modelSelected(TodoCellViewModel.self)
            .bind(to: viewModel.itemDidSelect)
            .addDisposableTo(disposeBag)

        tableview.rx.itemDeleted
            .bind(to: viewModel.itemDeleted)
            .addDisposableTo(disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reloadTodos)
            .addDisposableTo(disposeBag)

        // Bind View Model
        dataSource.configureCell = { _, tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell else {
                return UITableViewCell()
            }

            cell.configure(viewModel: viewModel)
            return cell
        }

        dataSource.canEditRowAtIndexPath = { _ in
            return true
        }

        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }

        viewModel.titleText
            .drive(rx.title)
            .addDisposableTo(disposeBag)

        viewModel.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)

        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .addDisposableTo(disposeBag)

        viewModel.sections
            .drive(tableview.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}
