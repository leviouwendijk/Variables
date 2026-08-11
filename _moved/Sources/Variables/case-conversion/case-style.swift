import Foundation

public enum CaseStyle: Sendable {
    case camel       // e.g. "myHTTPServer42"
    case snake       // e.g. "my_http_server_42"
    case pascal      // e.g. "MyHTTPServer42"
}
