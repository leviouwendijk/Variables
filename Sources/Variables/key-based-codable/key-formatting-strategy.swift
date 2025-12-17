public enum KeyFormattingStrategy: Sendable {
    case raw
    case uppercased
    case lowercased
    case capitalized
    case custom(@Sendable (String) -> String)

    @inline(__always)
    public func apply(_ s: String) -> String {
        switch self {
        case .raw:            return s
        case .uppercased:     return s.uppercased()
        case .lowercased:     return s.lowercased()
        case .capitalized:    return s.capitalized
        case .custom(let f):  return f(s)
        }
    }
}
