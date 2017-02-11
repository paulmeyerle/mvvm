//
//  TodoCell.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit

class TodoCell : UITableViewCell {
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: TodoCellViewModelType) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        self.accessoryType = viewModel.accessoryType
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
        }
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.descriptionLabel)
    }
}
