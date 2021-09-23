//
//  ReposBuilder.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 23.09.2021.
//

import Foundation

class ReposBuilder {
    
    static func build() -> ReposViewController {
        let service = ReposService()
        let presenter = ReposPresenter(service: service)
        let viewController = ReposViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
