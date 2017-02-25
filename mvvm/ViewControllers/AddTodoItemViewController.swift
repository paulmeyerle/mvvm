//
//  AddTodoItemViewController.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import RxSwift

class AddTodoItemViewController: BaseViewController {

    fileprivate let disposeBag = DisposeBag()

    let viewModel: AddTodoViewModelType

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    let titleInput = UITextField().then {
        $0.placeholder = "Beer Name"
        $0.borderStyle = .roundedRect
    }

    let saveButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 5
    }

    init(viewModel: AddTodoViewModelType) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a Beer"
        setupLayout()
        configure()
    }

    private func setupLayout() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(20)
        }

        titleInput.snp.makeConstraints { maker in
            maker.height.equalTo(30)
        }

        stackView.addArrangedSubview(titleInput)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(UIView())
    }

    private func configure() {
        titleInput.rx.text
            .bindTo(viewModel.title)
            .addDisposableTo(disposeBag)

        saveButton.rx.tap
            .bindTo(viewModel.saveButtonItemDidTap)
            .addDisposableTo(disposeBag)

        viewModel.isValid
            .drive(saveButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }

}
