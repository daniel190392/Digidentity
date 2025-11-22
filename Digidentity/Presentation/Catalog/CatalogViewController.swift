//
//  CatalogViewController.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Combine
import UIKit

class CatalogViewController: UIViewController {
    private let viewModel: CatalogViewModel
    private var cancellables = Set<AnyCancellable>()
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

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
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
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &cancellables)
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
                emptyView.configure(message: "No Items")
            }
            tableView.reloadData()
        case .error(let message):
            tableView.isHidden = true
            emptyView.isHidden = true
            activityIndicator.stopAnimating()
            showPopup(title: "Error", message: message)
        }
    }
}

// MARK: Setup Layout
private extension CatalogViewController {
    func setupAutoLayout() {
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

    func showPopup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
            cell.configure(with: item)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension CatalogViewController: UITableViewDelegate { }
