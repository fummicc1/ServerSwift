class HTTP {
    
    struct StatusCode {
        let value: Int
        
        var messege: String {
            switch value {
            case 200:
                return "OK"
            case 404:
                return "Not Found"
            default:
                return "Not implemented"
            }
        }
        
        init(_ value: Int) {
            self.value = value
        }
    }
    
    let statusCode: [StatusCode] = [
        StatusCode(200),
        StatusCode(404)
    ]
    
    static func createServer() -> HTTPServer {
        HTTPServer()
    }
}
