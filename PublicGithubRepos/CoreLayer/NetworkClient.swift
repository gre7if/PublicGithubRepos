//
//  NetworkClient.swift
//  CurrencyChart
//
//  Created by Rustam Nigmatzyanov on 06.09.2021.
//

import Foundation

// MARK: - NetworkRequest
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
//    func decode(_ data: Data) -> ModelType?
    func loadData(completion: @escaping(ModelType) -> Void)
}

// MARK: - APIResource
protocol APIResource {
    associatedtype ModelType: Decodable
    var sinceId: String { get }
}

extension APIResource {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/repositories"
        components.queryItems = [
            URLQueryItem(name: "since", value: "\(sinceId)")
        ]
        return components.url
    }
}

// MARK: - APIRequest
class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {

    func loadData(completion: @escaping(Resource.ModelType) -> Void) {
        guard let url = resource.url else {
            print ("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Something went wrong with getting data...")
                return
            }
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(Resource.ModelType.self, from: data)
                completion(value)
            } catch let error {
                print("\nFailed to convert: \(error.localizedDescription)\n")
            }
        }
        task.resume()
    }
    
//    func decode(_ data: Data) -> Resource.ModelType? {
//        let decoder = JSONDecoder()
//        do {
//            let value = try decoder.decode(Resource.ModelType.self, from: data)
//            return value
//        }
//        catch {
//            return nil
//        }
//    }
}

// MARK: - RepositoryResource
struct RepositoryResource: APIResource {
    typealias ModelType = Repositories

    var sinceId: String    
}

