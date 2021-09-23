//
//  ReposService.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 23.09.2021.
//

import Foundation

protocol ReposServiceProtocol {
    func updateReposList(id: Int, _ completion: @escaping(Repositories) -> Void)
}

class ReposService: ReposServiceProtocol {
    
    func updateReposList(id: Int, _ completion: @escaping (Repositories) -> Void) {
        let resource = RepositoryResource(sinceId: String(id))
        let request = APIRequest(resource: resource)
        
        request.loadData { repositories in
            completion(repositories)
        }
    }
}
