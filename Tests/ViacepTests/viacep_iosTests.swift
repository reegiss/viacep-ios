import XCTest
@testable import Viacep

final class viacep_iosTests: XCTestCase {
    
    var client: ViacepClient!
    
    override func setUp() {
        super.setUp()
        client = ViacepClient()
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }
    
    // MARK: - Async/Await Tests
    
    func testFetchAddressWithValidCEP() async throws {
        // Given
        let cep = "01001000"
        
        // When
        let address = try await client.fetchAddress(cep: cep)
        
        // Then
        XCTAssertEqual(address.cep, "01001-000")
        XCTAssertFalse(address.logradouro.isEmpty)
        XCTAssertEqual(address.uf, "SP")
    }
    
    func testFetchAddressWithInvalidCEP() async {
        // Given
        let invalidCEP = "12345"
        
        // When/Then
        do {
            _ = try await client.fetchAddress(cep: invalidCEP)
            XCTFail("Should have thrown an error")
        } catch let error as ViacepError {
            if case .invalidCEP = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCEP error, got \(error)")
            }
        } catch {
            XCTFail("Expected ViacepError, got \(error)")
        }
    }
    
    func testFetchAddressWithNonNumericCEP() async {
        // Given
        let invalidCEP = "abcd1234"
        
        // When/Then
        do {
            _ = try await client.fetchAddress(cep: invalidCEP)
            XCTFail("Should have thrown an error")
        } catch let error as ViacepError {
            if case .invalidCEP = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCEP error, got \(error)")
            }
        } catch {
            XCTFail("Expected ViacepError, got \(error)")
        }
    }
    
    func testIsValidCEP() {
        // Valid CEPs
        XCTAssertTrue(ViacepClient.isValidCEP("01001000"))
        XCTAssertTrue(ViacepClient.isValidCEP("01001-000"))
        
        // Invalid CEPs
        XCTAssertFalse(ViacepClient.isValidCEP("1234567"))    // Too short
        XCTAssertFalse(ViacepClient.isValidCEP("123456789"))  // Too long
        XCTAssertFalse(ViacepClient.isValidCEP("abcd1234"))   // Non-numeric
        XCTAssertFalse(ViacepClient.isValidCEP(""))           // Empty
    }
    
    // MARK: - Completion Handler Tests (Backward Compatibility)
    
    func testFetchAddressWithCompletionHandler() {
        // Given
        let cep = "01001000"
        let expectation = expectation(description: "Fetch address")
        
        // When
        client.fetchAddress(cep: cep) { result in
            // Then
            switch result {
            case .success(let address):
                XCTAssertEqual(address.cep, "01001-000")
                XCTAssertFalse(address.logradouro.isEmpty)
                XCTAssertEqual(address.uf, "SP")
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Legacy API Tests
    
    func testLegacyAPIWithConvenienceInit() {
        // Given
        let cep = "01001000"
        let expectation = expectation(description: "Fetch address")
        
        // When - Using legacy API
        client.requestCep(cep: cep) { error, address in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(address)
            if let address = address {
                XCTAssertEqual(address.cep, "01001-000")
                XCTAssertEqual(address.uf, "SP")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLegacyHasErrorCep() {
        // Valid CEPs
        XCTAssertFalse(client.hasErrorCep(cep: "01001000"))
        XCTAssertFalse(client.hasErrorCep(cep: "01001-000"))
        
        // Invalid CEPs
        XCTAssertTrue(client.hasErrorCep(cep: "123"))
        XCTAssertTrue(client.hasErrorCep(cep: ""))
    }
}
