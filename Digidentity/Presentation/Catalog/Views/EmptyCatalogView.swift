//
//  EmptyCatalogView.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

final class EmptyCatalogView: UIView {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let imageSize: CGFloat = 80
    }
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "tray")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reload", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    var onActionTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(message: String, showButton: Bool = true, buttonTitle: String? = nil) {
        messageLabel.text = message
        actionButton.isHidden = !showButton
        if let title = buttonTitle {
            actionButton.setTitle(title, for: .normal)
        }
    }
}

// MARK: Setup Layout
private extension EmptyCatalogView {
    func setupView() {
        setupImageView()
        setupMessageLabel()
        setupActionButton()
        isHidden = true
    }

    func setupImageView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(Constants.imageSize/2)),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }

    func setupMessageLabel() {
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.horizontalMargin),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalMargin),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalMargin)
        ])
    }

    func setupActionButton() {
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Constants.horizontalMargin),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Actions
private extension EmptyCatalogView {
    @objc
    func buttonTapped() {
        onActionTap?()
    }
}
