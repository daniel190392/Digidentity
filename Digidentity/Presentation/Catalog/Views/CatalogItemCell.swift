//
//  CatalogItemCell.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

class CatalogItemCell: UITableViewCell {
    static let reuseIdentifier = "CatalogItemCell"
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 8
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        titleLabel.text = item.text
    }
}

private extension CatalogItemCell {
    func setupLayout() {
        setupTitle()
    }

    func setupTitle() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Constants.horizontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Constants.horizontalMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin)
        ])
    }
}
