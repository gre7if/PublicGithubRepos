//
//  DetailedRepoViewConntroller.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 23.09.2021.
//

import UIKit

class DetailedRepoViewController: UIViewController {
    
    private let viewModel: RepoViewModel
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}
