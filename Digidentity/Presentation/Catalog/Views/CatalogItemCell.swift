//
//  CatalogItemCell.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

struct ItemCellViewModel {
    let titleText: String
    let idText: String
    let confidenceValue: Double
    let image: String
}

class CatalogItemCell: UITableViewCell {

    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 8
        static let imageSize: CGFloat = 60
        static let space: CGFloat = 8
    }
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.space
        stack.alignment = .center
        return stack
    }()
    private var itemImageView = UIImageView()
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.space / 2
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private let identifierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private let confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    private var loadImageTask: Task<Void, Never>?

    static let reuseIdentifier = "CatalogItemCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        titleLabel.text = nil
        identifierLabel.text = nil
        confidenceLabel.text = nil
        confidenceLabel.textColor = .clear
    }

    func configure(with item: ItemCellViewModel) {
        loadImageTask?.cancel()
        itemImageView.image = UIImage(systemName: "tray")
        titleLabel.text = item.titleText
        identifierLabel.text = item.idText
        confidenceLabel.text = String(format: "%.2f", item.confidenceValue)
        confidenceLabel.textColor = item.confidenceValue >= 0.5 ? .systemGreen : .systemRed
        loadImageTask = Task {
            guard let imageUrl = URL(string: item.image),
                let image = await ImageLoader.shared.loadImage(imageUrl),
                !Task.isCancelled
                else { return }
            itemImageView.image = image
        }
    }
}

// MARK: Setup Layout
private extension CatalogItemCell {
    func setupLayout() {
        setupStackView()
        setupItemImageView()
        setupTextStackView()
        setupTitleLabel()
        setupIdentifierLabel()
        setupConfidenceLabel()
    }

    func setupStackView() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.horizontalMargin),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Constants.horizontalMargin),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin)
        ])
    }

    func setupItemImageView() {
        stackView.addArrangedSubview(itemImageView)
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            itemImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }

    func setupTextStackView() {
        stackView.addArrangedSubview(textStackView)
    }

    func setupTitleLabel() {
        textStackView.addArrangedSubview(titleLabel)
    }

    func setupIdentifierLabel() {
        textStackView.addArrangedSubview(identifierLabel)
    }

    func setupConfidenceLabel() {
        stackView.addArrangedSubview(confidenceLabel)
    }
}
