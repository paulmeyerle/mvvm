//
//  AddTodoItemViewController.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import RxSwift

class AddTodoItemViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let viewModel: AddTodoViewModelType

    private let titleInput = UITextField().then {
        $0.placeholder = "Beer Name"
        $0.borderStyle = .roundedRect
        $0.font = .preferredFont(forTextStyle: .title3)
    }

    private let saveButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = .preferredFont(forTextStyle: .title3)
    }

    init(viewModel: AddTodoViewModelType) {
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

        let stackView = UIStackView(arrangedSubviews: [titleInput, saveButton]) .then {
            $0.axis = .vertical
            $0.spacing = 20
        }

        view.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview()
                .inset(20)
        }

        titleInput.snp.makeConstraints { maker in
            maker.height.equalTo(50)
        }
    }

    private func configure() {
        titleInput.rx.text
            .bind(to: viewModel.title)
            .addDisposableTo(disposeBag)

        saveButton.rx.tap
            .bind(to: viewModel.saveButtonItemDidTap)
            .addDisposableTo(disposeBag)

        viewModel.isValid
            .drive(saveButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        viewModel.titleText
            .drive(rx.title)
            .addDisposableTo(disposeBag)
    }
}
