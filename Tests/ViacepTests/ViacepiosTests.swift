import XCTest
@testable import Viacep

final class ViacepiosTests: XCTestCase {
    
    func testModernAsyncAPI() async throws {
        // Given
        let client = ViacepClient()
        let cep = "01001000"
        
        // When
        let address = try await client.fetchAddress(cep: cep)
        
        // Then
        XCTAssertNotNil(address)
        XCTAssertEqual(address.cep, "01001-000")
        XCTAssertEqual(address.uf, "SP")
    }
    
    func testLegacyCompatibility() {
        // Given
        let client = ViacepClient()
        let cep = "01001000"
        let expectation = expectation(description: "Legacy API")
        
        // When - Using legacy method signature
        client.requestCep(cep: cep) { error, address in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(address)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
