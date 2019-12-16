protocol Server {
    var port: Int? { get }
    var address: String? { get }
    
    func listen(on port: Int?, address: String?) throws
}

class HTTPServer: Server {
    var port: Int?
    var address: String?
    
    func listen(on port: Int?, address: String?) throws {
        
    }
}
