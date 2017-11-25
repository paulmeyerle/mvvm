//
//  TodoCell.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    let titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        selectionStyle = .none

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(15)
        }
    }

    func configure(viewModel: TodoCellViewModelType) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        accessoryType = viewModel.accessoryType
    }
}
