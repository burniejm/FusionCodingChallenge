//
//  NewsDetailViewController.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit
import NVActivityIndicatorView

class NewsDetailViewController: UIViewController {

    private var viewModel: NewsDetailViewModelProtocol!

    private var disposeBag = DisposeBag()

    private var webView: WKWebView!
    private var activityIndicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupSubviews()
        setupBindings()

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

    }

    func setup(viewModel: NewsDetailViewModelProtocol) -> Self {

        self.viewModel = viewModel

        return self

    }

    func setupSubviews() {

        self.view.backgroundColor = .white

        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { make in
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

    func setupBindings() {

        self.viewModel.publication
            .bind { [weak self] _ in
                self?.loadPublication()
        }

    }

    private func loadPublication() {

        guard let publication = self.viewModel.publication.value else { return }

        self.title = publication.newsSite

        if let url = URL(string:publication.url) {

            self.setLoadingVisible(true)

            DispatchQueue.main.async {

                //Getting main thread warnings here in xcode but not sure why

                let request = URLRequest(url: url)
                self.webView.load(request)

            }

        }

    }

    private func setLoadingVisible(_ visible: Bool) {

        if visible {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }

    }

}

extension NewsDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.setLoadingVisible(false)
    }

}
