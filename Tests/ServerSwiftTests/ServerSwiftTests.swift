import XCTest
@testable import ServerSwift

final class ServerSwiftTests: XCTestCase {
    
    func testTCPConnection() {
        let server = HTTP.createServer()
        try? server.listen(on: 8080, address: "localhost")
    }

    
    
    static var allTests = [
        ("testExample", testTCPConnection),
    ]
}
