//
//  ViacepServices.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 11/02/21.
//

import Foundation

class ViacepServices {
    
    public static let shared = ViacepServices()
    
    private init() {}
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    //    GET {cep}/json/
    private func getUrlFromViacep(_ cep: String) -> String {
        return "\(API_ENDPOINT)/\(cep)/json"
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard URLComponents(url: url, resolvingAgainstBaseURL: true) != nil else {
            completion(.failure(.invalidEndpoint))
            return
        }
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    
    public func fetchCep(cep: String, result: @escaping (Result<Address, APIServiceError>) -> Void) {
        let url = URL(string: getUrlFromViacep(cep))
        fetchResources(url: url!, completion: result)
    }
    
}
