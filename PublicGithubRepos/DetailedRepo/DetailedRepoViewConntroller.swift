//
//  DetailedRepoViewConntroller.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 23.09.2021.
//

import UIKit

class DetailedRepoViewController: UIViewController {
    
    var viewModel: RepoViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        if let model = viewModel {
            print(model.id)
        }
    }
}
