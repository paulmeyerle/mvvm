//
//  ViewTodoItemViewController.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit

class ViewTodoItemViewController: BaseViewController {
    
    let viewModel: ViewTodoViewModelType
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    init(viewModel: ViewTodoViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "View Todo"
        self.setupLayout()
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.titleLabel.text = self.viewModel.title
        self.descriptionLabel.text = self.viewModel.description
    }
    
    private func setupLayout() {
        self.view.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
        }
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.descriptionLabel)
    }

}
