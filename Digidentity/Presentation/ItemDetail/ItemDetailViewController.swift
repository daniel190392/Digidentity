//
//  ItemDetailViewController.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

class ItemDetailViewController: UIViewController {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let imageSize: CGFloat = 200
        static let largeFontSize: CGFloat = 22
        static let normalFontSize: CGFloat = 16
        static let space: CGFloat = 8
        static let screenTitle = "Item Detail"
    }
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    private lazy var detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.space
        stack.alignment = .leading
        return stack
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.largeFontSize, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.normalFontSize, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var confidenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.normalFontSize, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()

    private let viewModel: ItemDetailViewModel
    private var loadImageTask: Task<Void, Never>?

    init(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
        bindViewModel()
        viewModel.loadItem()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadImageTask?.cancel()
    }
}

// MARK: Binding
private extension ItemDetailViewController {
    func bindViewModel() {
        viewModel.bind { [weak self] state in
            self?.render(state: state)
        }
    }

    func render(state: ItemDetailViewModel.ItemDetailViewState) {
        switch state {
        case .none:
            break
        case .loaded(let item):
            configure(with: item)
        }
    }

    func configure(with item: Item) {
        itemImageView.image = UIImage(systemName: "tray")
        titleLabel.text = item.text
        idLabel.text = item.id
        confidenceLabel.text = String(format: "%.2f", item.confidence)
        confidenceLabel.textColor = item.confidence >= 0.5 ? .systemGreen : .systemRed
        loadImageTask = Task { [weak self] in
            guard let self = self else { return }

            guard let url = URL(string: item.image),
                let image = await ImageLoader.shared.loadImage(url),
                !Task.isCancelled
                else { return }
            self.itemImageView.image = image
        }
    }
}

// MARK: Setup Layout
private extension ItemDetailViewController {
    func setupAutoLayout() {
        view.backgroundColor = .white
        title = Constants.screenTitle
        setupItemImageView()
        setupDetailsStackView()
        setupTitleLabel()
        setupIdLabel()
        setupConfidenceLabel()
    }

    func setupItemImageView() {
        view.addSubview(itemImageView)
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }

    func setupDetailsStackView() {
        view.addSubview(detailsStackView)
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor,
                                                  constant: Constants.horizontalMargin),
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: Constants.horizontalMargin),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -Constants.horizontalMargin)
        ])
    }

    func setupTitleLabel() {
        detailsStackView.addArrangedSubview(titleLabel)
    }

    func setupIdLabel() {
        detailsStackView.addArrangedSubview(idLabel)
    }

    func setupConfidenceLabel() {
        detailsStackView.addArrangedSubview(confidenceLabel)
    }
}
