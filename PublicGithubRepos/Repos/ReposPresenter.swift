//
//  ReposPresenter.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 06.10.2021.
//

import Foundation

class ReposPresenter: ReposViewControllerOutput {
    
    weak var view: ReposViewControllerInput?
    private let service: ReposService
    
    init(service: ReposService) {
        self.service = service
    }
    
    func prepareData(id: Int) {
        service.updateReposList(id: id) { [weak self] repositories in
            guard let self = self,
                  let view = self.view
            else { return }
            
            let viewModel: [RepoViewModel] = repositories.compactMap { repository in
                var description = ""
                if let descr = repository.repositoryDescription {
                    description = descr
                }
                
                let result = RepoViewModel(
                    id: repository.id,
                    name: repository.name,
                    ownerLogin: repository.owner.login,
                    description: description
                )
                return result
            }
            
            DispatchQueue.main.async {
                view.setupView(viewModel: viewModel)
                view.reloadView()
            }
        }
    }
    
    func prepareDataByRefresh(id: Int) {
        service.updateReposList(id: id) { [weak self] repositories in
            guard let self = self,
                  let view = self.view
            else { return }
            
            let viewModel: [RepoViewModel] = repositories.compactMap { repository in
                var description = ""
                if let descr = repository.repositoryDescription {
                    description = descr
                }
                
                let result = RepoViewModel(
                    id: repository.id,
                    name: repository.name,
                    ownerLogin: repository.owner.login,
                    description: description
                )
                return result
            }
            
            DispatchQueue.main.async {
                view.setupViewByRefresh(viewModel: viewModel)
                view.stopRefreshing()
                view.reloadView()
            }
        }
    }
}
