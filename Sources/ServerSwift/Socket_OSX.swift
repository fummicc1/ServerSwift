import Foundation

class Socket_OSX {
    
    private static let SOCKET_MAC_BACKLOG = 50
    
    var config: Config?
    var socketfd: UInt32?
    
    struct Config {
        let protocolFamily: ProtocolFamily
        let protocolType: ProtocolType
        let socketProtocol: SocketProtocol
        let hostname: String?
        let port: Int32?
        
        init(family protocolFamily: ProtocolFamily, type protocolType: ProtocolType, protocol socketProtocol: SocketProtocol, hostname: String?, port: Int32?) {
            self.protocolFamily = protocolFamily
            self.protocolType = protocolType
            self.socketProtocol = socketProtocol
            self.hostname = hostname
            self.port = port
        }
        
        
    }
    
    init(_ config: Config) throws {
        self.config = config
        
        let socketfd = Darwin.socket(config.protocolFamily.value, config.protocolType.value, config.socketProtocol.value)
        
        if socketfd < 0 {
            throw Error(message: "Negative socketfd was returned.")
        }
        
        self.socketfd = UInt32(socketfd)
    }
    
    public func bind(_ path: String, backlog: Int) throws {
        guard let socketfd = socketfd else {
            throw Error(message: "No socketfd was found.")
        }
        
        guard let config = config else {
            throw Error(message: "Need to set config before bind.")
        }
        
        // unlink path just in case path exists.
        _ = Darwin.unlink(path)
        
        
    }
    
    enum ProtocolFamily {
        // AF_INET(IPV4)
        case inet
        // AF_INET(IPV6)
        case inet6
        // AF_UNIX
        case unix
        
        var value: Int32 {
            switch self {
            case .inet:
                return AF_INET
            case .inet6:
                return AF_INET6
            case .unix:
                return AF_UNIX
            }
        }
    }
    
    enum ProtocolType {
        case stream
        case datagram
        
        var value: Int32 {
            switch self {
            case .stream:
                return SOCK_STREAM
            case .datagram:
                return SOCK_DGRAM
            }
        }
    }
    
    enum SocketProtocol {
        // IPPROTO_TCP
        case tcp
        // IPPROTO_UDP
        case udp
        // Unix Domain
        case unix
        
        var value: Int32 {
            switch self {
            case .tcp:
                return IPPROTO_TCP
            case .udp:
                return IPPROTO_UDP
            case .unix:
                return Int32(0) // implicit
            }
        }
    }
    
    /// storing socket data with enum associated value
    enum Address {
        // sockaddr_in
        case ipv4(sockaddr_in)

        // sockaddr_in6
        case ipv6(sockaddr_in6)

        // sockaddr_un
        case unix(sockaddr_un)
        
        var size: Int {
            switch self {
            case .ipv4(_):
                return MemoryLayout<sockaddr_in>.size
            case .ipv6(_):
                return MemoryLayout<sockaddr_in6>.size
            case .unix(_):
                return MemoryLayout<sockaddr_un>.size
            }
        }
    }
    
}

extension Socket_OSX {
    struct Error: Swift.Error {
        
        // TODO: need to declare ErrorCode.
        let errorCode: Int32
        let message: String
        
        init(code errorCode: Int32 = -1, message: String) {
            self.errorCode = errorCode
            self.message = message
        }
    }
}
