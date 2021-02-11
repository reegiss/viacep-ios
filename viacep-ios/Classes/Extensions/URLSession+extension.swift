//
//  URLSession+extension.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 02.02.2021.
//  Email regis@r3tecnologia.net
//  Copyright © 2021 R3Tecnologia.net. All rights reserved.
//

import Foundation

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
}
