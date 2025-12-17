import Foundation

public enum SyntheticSymbolError: Error, LocalizedError {
    case nameIsEmpty

    public var errorDescription: String? {
        switch self {
        case .nameIsEmpty: 
            return "Cannot synthesize from empty name"
        }
    }
}
