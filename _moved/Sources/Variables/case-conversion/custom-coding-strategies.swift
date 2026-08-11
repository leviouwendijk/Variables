import Foundation

public struct CustomStrategies {
    public static func encodeKeys(
        to style: CaseStyle,
        separators: SeparatorPolicy = .commonWithDot
    ) -> JSONEncoder.KeyEncodingStrategy {
        .custom { keys in
            let last = keys.last!.stringValue
            return AnyKey(stringValue: convertIdentifier(last, to: style, separators: separators))!
        }
    }

    public static func decodeKeys(
        from _: CaseStyle,
        to target: CaseStyle = .camel,
        separators: SeparatorPolicy = .commonWithDot
    ) -> JSONDecoder.KeyDecodingStrategy {
        .custom { keys in
            let last = keys.last!.stringValue
            return AnyKey(stringValue: convertIdentifier(last, to: target, separators: separators))!
        }
    }

    // Back-compat names
    public static func encodeCamelToSnake(separators: SeparatorPolicy = .commonWithDot) -> JSONEncoder.KeyEncodingStrategy {
        encodeKeys(to: .snake, separators: separators)
    }
    public static func encodeSnakeToCamel(separators: SeparatorPolicy = .commonWithDot) -> JSONEncoder.KeyEncodingStrategy {
        encodeKeys(to: .camel, separators: separators)
    }
    public static func decodeFromSnakeToCamel(separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder.KeyDecodingStrategy {
        decodeKeys(from: .snake, to: .camel, separators: separators)
    }
    public static func decodeFromCamelToSnake(separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder.KeyDecodingStrategy {
        decodeKeys(from: .camel, to: .snake, separators: separators)
    }
}
