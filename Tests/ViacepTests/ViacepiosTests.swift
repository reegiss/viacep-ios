import XCTest
@testable import Viacep

final class ViacepiosTests: XCTestCase {
    func testExample() throws {

        let viacep = Viacep(cep: "01001000")
        viacep.requestCep { (error, address) in
            XCTAssertNil(error)
            XCTAssertNotNil(address)
            
        }

        
        // XCTAssertEqual(Viacep(cep: "74305-440"), "Hello, World!")
    }
}
