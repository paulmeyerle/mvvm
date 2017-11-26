//
//  TodoCell.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import UIKit
import Then
import SnapKit

class TodoItemCellView: UITableViewCell {

    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.numberOfLines = 0
    }

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
            maker.edges.equalToSuperview()
                .inset(15)
        }
    }

    public func configure(viewModel: TodoItemCellViewModelType) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        accessoryType = viewModel.accessoryType
    }
}
