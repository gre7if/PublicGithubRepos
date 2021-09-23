//
//  DetailedRepoViewConntroller.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 23.09.2021.
//

import UIKit
import WebKit

class DetailedRepoViewController: UIViewController {
    
    private lazy var contentView = DetailedRepoView()
    private var webView: WKWebView { contentView.webView }
    
    private let viewModel: RepoViewModel
    var urlString = ""
    
    init(viewModel: RepoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        title = viewModel.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadRepository()
    }
    
    func loadRepository() {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        print(url)
    }
}
