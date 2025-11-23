//
//  CatalogViewController.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

class CatalogViewController: UIViewController {
    private enum Constants {
        static let screenTitle = "Catalog"
        static let emptyListMessage = "No Items"
        static let popupTitle = "Error"
        static let popupButton = "Ok"
    }
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CatalogItemCell.self, forCellReuseIdentifier: CatalogItemCell.reuseIdentifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let emptyView = EmptyCatalogView()

    private let viewModel: CatalogViewModel

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
        bindViewModel()
        loadCatalog()
    }

    func loadCatalog() {
        Task {
            await viewModel.loadCatalog()
        }
    }
}

// MARK: Binding
private extension CatalogViewController {
    func bindViewModel() {
        viewModel.bind { [weak self] state in
            self?.render(state: state)
        }
    }

    func render(state: CatalogViewModel.CatalogViewState) {
        switch state {
        case .none:
            tableView.isHidden = true
            emptyView.isHidden = true
            activityIndicator.stopAnimating()
        case .loading:
            tableView.isHidden = true
            emptyView.isHidden = true
            activityIndicator.startAnimating()
        case .loaded(let items):
            tableView.isHidden = false
            activityIndicator.stopAnimating()
            emptyView.isHidden = !items.isEmpty
            if items.isEmpty {
                emptyView.configure(message: Constants.emptyListMessage)
            }
            tableView.reloadData()
        case .error(let message):
            tableView.isHidden = true
            emptyView.isHidden = true
            activityIndicator.stopAnimating()
            showPopup(message: message)
        case .loadingMore:
            break
        }
    }
}

// MARK: Setup Layout
private extension CatalogViewController {
    func setupAutoLayout() {
        view.backgroundColor = .white
        title = Constants.screenTitle
        setupTableView()
        setupActivityIndicator()
        setupEmptyView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        emptyView.onActionTap = { [weak self] in
            self?.loadCatalog()
        }
   }

    func showPopup(message: String) {
        let alert = UIAlertController(title: Constants.popupTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.popupButton, style: .default))
        present(alert, animated: true)
    }
}

// MARK: UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .loaded(let items) = viewModel.state {
            return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogItemCell.reuseIdentifier,
                                                 for: indexPath) as! CatalogItemCell
        if case .loaded(let items) = viewModel.state {
            let item = items[indexPath.row]
            cell.configure(with: item.toItemCellViewModel())
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard case .loaded(let items) = viewModel.state else { return }

        let lastIndex = items.count - 1
        if indexPath.row == lastIndex {
            Task {
                await viewModel.loadNextPage()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }
}
