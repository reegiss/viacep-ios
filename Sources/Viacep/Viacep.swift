//
//  Viacep.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 11/02/21.
//

import Foundation

/// Main client for fetching Brazilian postal code (CEP) information
///
/// This client provides both async/await and completion handler APIs
/// for fetching address data from the ViaCEP service.
///
/// Example usage with async/await:
/// ```swift
/// let client = ViacepClient()
/// do {
///     let address = try await client.fetchAddress(cep: "01001000")
///     print(address.logradouro)
/// } catch {
///     print("Error: \(error)")
/// }
/// ```
///
/// Example usage with completion handler:
/// ```swift
/// let client = ViacepClient()
/// client.fetchAddress(cep: "01001000") { result in
///     switch result {
///     case .success(let address):
///         print(address.logradouro)
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// }
/// ```
public final class ViacepClient {
    
    private let service: ViacepService
    
    /// Initialize a new ViaCEP client
    /// - Parameter service: The service to use for API requests. Defaults to a new instance.
    public init(service: ViacepService = ViacepService()) {
        self.service = service
    }
    
    /// Validates if a CEP string has the correct format
    /// - Parameter cep: The CEP string to validate
    /// - Returns: `true` if the CEP has 8 digits (with or without hyphen), `false` otherwise
    public static func isValidCEP(_ cep: String) -> Bool {
        let cleanCEP = cep.replacingOccurrences(of: "-", with: "")
        return cleanCEP.count == 8 && cleanCEP.allSatisfy(\.isNumber)
    }
    
    /// Fetches address information for a given CEP using async/await
    /// - Parameter cep: Brazilian postal code (8 digits, with or without hyphen)
    /// - Returns: Address information
    /// - Throws: ViacepError if the request fails or CEP is invalid
    public func fetchAddress(cep: String) async throws -> Address {
        try await service.fetchAddress(cep: cep)
    }
    
    /// Fetches address information for a given CEP using completion handler
    /// - Parameters:
    ///   - cep: Brazilian postal code (8 digits, with or without hyphen)
    ///   - completion: Completion handler called with the result
    public func fetchAddress(cep: String, completion: @escaping (Result<Address, ViacepError>) -> Void) {
        Task {
            do {
                let address = try await service.fetchAddress(cep: cep)
                completion(.success(address))
            } catch let error as ViacepError {
                completion(.failure(error))
            } catch {
                completion(.failure(.networkError(error)))
            }
        }
    }
}

// MARK: - Backward Compatibility

/// Legacy class name for backward compatibility
/// - Note: Use `ViacepClient` for new code
@available(*, deprecated, renamed: "ViacepClient", message: "Use ViacepClient instead")
public typealias Viacep = ViacepClient

extension ViacepClient {
    
    /// Legacy singleton instance for backward compatibility
    /// - Note: Creating new instances with dependency injection is preferred
    @available(*, deprecated, message: "Create instances directly instead of using singleton")
    public static var shared: ViacepClient {
        ViacepClient()
    }
    
    /// Legacy method for backward compatibility
    /// - Note: Use `isValidCEP(_:)` instead
    @available(*, deprecated, renamed: "isValidCEP", message: "Use static method isValidCEP(_:) instead")
    public func hasErrorCep(cep: String) -> Bool {
        !Self.isValidCEP(cep)
    }
    
    /// Legacy method for backward compatibility
    /// - Note: Use `fetchAddress(cep:completion:)` instead
    @available(*, deprecated, message: "Use fetchAddress(cep:completion:) instead")
    public func requestCep(cep: String, completion: @escaping (Error?, Address?) -> Void) {
        fetchAddress(cep: cep) { result in
            switch result {
            case .success(let address):
                completion(nil, address)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}
