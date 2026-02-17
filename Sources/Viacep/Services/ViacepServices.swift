//
//  ViacepServices.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 11/02/21.
//

import Foundation

/// Service errors that can occur when fetching address data
public enum ViacepError: LocalizedError {
    case invalidCEP
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodingError(Error)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidCEP:
            return "The provided CEP format is invalid. Expected 8 digits."
        case .invalidEndpoint:
            return "The request endpoint could not be constructed."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        }
    }
}

/// Service for fetching Brazilian postal code (CEP) information from ViaCEP API
actor ViacepService {
    
    private let urlSession: URLSession
    private let baseURL = "https://viacep.com.br/ws"
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    /// Initialize the service with a custom URLSession
    /// - Parameter urlSession: URLSession to use for network requests. Defaults to `.shared`
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Fetches address information for a given CEP
    /// - Parameter cep: Brazilian postal code (8 digits, with or without hyphen)
    /// - Returns: Address information
    /// - Throws: ViacepError if the request fails
    public func fetchAddress(cep: String) async throws -> Address {
        // Validate and clean CEP
        let cleanCEP = cep.replacingOccurrences(of: "-", with: "")
        guard cleanCEP.count == 8, cleanCEP.allSatisfy(\.isNumber) else {
            throw ViacepError.invalidCEP
        }
        
        // Construct URL
        guard let url = URL(string: "\(baseURL)/\(cleanCEP)/json") else {
            throw ViacepError.invalidEndpoint
        }
        
        // Perform request
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(from: url)
        } catch {
            throw ViacepError.networkError(error)
        }
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ViacepError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ViacepError.invalidResponse
        }
        
        // Decode response
        do {
            let address = try jsonDecoder.decode(Address.self, from: data)
            return address
        } catch {
            throw ViacepError.decodingError(error)
        }
    }
}
