//
//  NewsViewController.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class NewsListViewController: UIViewController {

    private var viewModel: PublicationListViewModelProtocol!
    private var dateTimeService: DateTimeServiceProtocol!

    private var tableView: UITableView!
    private var activityIndicatorView: NVActivityIndicatorView!

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupSubviews()
        setupBindings()

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.tableView.reloadData()

    }

    func setup(viewModel: PublicationListViewModelProtocol,
               dateTimeService: DateTimeServiceProtocol) -> Self {

        self.viewModel = viewModel
        self.dateTimeService = dateTimeService

        return self

    }

    private func setupSubviews() {

        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 80.0

        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshList),
            for: .valueChanged
        )

        self.tableView.register(
            NewsTableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier
        )

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let activityIndicatorFrame = CGRect(
            x: 0,
            y: 0,
            width: 30.0,
            height: 30.0
        )

        self.activityIndicatorView = NVActivityIndicatorView(
            frame: activityIndicatorFrame,
            type: .pacman,
            color: .white
        )

        let activityBarButton = UIBarButtonItem(customView: self.activityIndicatorView)
        self.navigationItem.rightBarButtonItem = activityBarButton

    }

    private func setupBindings() {

        self.viewModel.title
            .bind { [weak self] in
                self?.title = $0
            }.disposed(by: self.disposeBag)

        self.viewModel.publications
            .bind { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: self.disposeBag)

        self.viewModel.isLoading
            .bind { [weak self] in
                self?.setLoadingVisible($0)
            }.disposed(by: self.disposeBag)

    }

    @objc
    private func refreshList() {
        self.viewModel.refreshTriggered()
    }

    private func setLoadingVisible(_ visible: Bool) {

        if visible {
            self.activityIndicatorView.startAnimating()
        } else {

            self.activityIndicatorView.stopAnimating()

            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }

        }

    }

}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.publications.value.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: NewsTableViewCell = tableView.dequeue(
            cellForRowAt: indexPath
        )

        let article = self.viewModel.publications.value[indexPath.row]

        return cell.setup(
            publication: article,
            dateTimeService: self.dateTimeService
        )

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        self.viewModel.select(articleAtIndex: indexPath.row)

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let totalCount = self.viewModel.publications.value.count

        if indexPath.row + self.viewModel.infiniteScrollThreshold > totalCount {
            self.viewModel.fetchNextArticles()
        }

    }

}
