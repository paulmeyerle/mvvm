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
    }
    
    let titleInput = UITextField().then {
        $0.placeholder = "Title"
    }
    
    let descriptionInput = UITextField().then {
        $0.placeholder = "Description"
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitle("Fill out the form", for: UIControlState.disabled)

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
        self.navigationItem.title = "Add a Todo"
        self.setupLayout()
        self.configure()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
        }
        self.stackView.addArrangedSubview(self.titleInput)
        self.stackView.addArrangedSubview(self.descriptionInput)
        self.stackView.addArrangedSubview(self.saveButton)
        
    }
    
    private func configure() {
        self.titleInput.rx.text
            .bindTo(self.viewModel.title)
            .addDisposableTo(self.disposeBag)
        
        self.descriptionInput.rx.text
            .bindTo(self.viewModel.description)
            .addDisposableTo(self.disposeBag)
        
        self.saveButton.rx.tap
            .bindTo(self.viewModel.saveButtonItemDidTap)
            .addDisposableTo(self.disposeBag)
        
        self.viewModel.isValid
            .drive(self.saveButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
    }
    
}
