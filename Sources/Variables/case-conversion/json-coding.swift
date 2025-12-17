import Foundation

extension JSONEncoder {
    /// Generic, style-driven encoder
    public static func encoder(keyCase: CaseStyle,
                               separators: SeparatorPolicy = .commonWithDot,
                               outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> JSONEncoder {
        let enc = JSONEncoder()
        enc.outputFormatting = outputFormatting
        enc.keyEncodingStrategy = .custom { path in
            let k = path.last!.stringValue
            return AnyKey(stringValue: convertIdentifier(k, to: keyCase, separators: separators))!
        }
        return enc
    }

    // Back-compat factories
    public static func snakeCaseEncoder(separators: SeparatorPolicy = .commonWithDot) -> JSONEncoder {
        encoder(keyCase: .snake, separators: separators)
    }
    public static func camelCaseEncoder(separators: SeparatorPolicy = .commonWithDot) -> JSONEncoder {
        encoder(keyCase: .camel, separators: separators)
    }
    public static func pascalCaseEncoder(separators: SeparatorPolicy = .commonWithDot) -> JSONEncoder {
        encoder(keyCase: .pascal, separators: separators)
    }
}

extension JSONDecoder {
    /// Generic, style-driven decoder. `from` is the expected style in the JSON input.
    /// `to` is the style your Swift property names use (default: camel).
    public static func decoder(from: CaseStyle,
                               to: CaseStyle = .camel,
                               separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .custom { path in
            let incoming = path.last!.stringValue
            let normalized = convertIdentifier(incoming, to: to, separators: separators)
            return AnyKey(stringValue: normalized)!
        }
        return dec
    }

    // Back-compat factories (assume structs use camelCase properties)
    public static func snakeCaseDecoder(separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder {
        decoder(from: .snake, to: .camel, separators: separators)
    }
    public static func camelCaseDecoder(separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder {
        decoder(from: .camel, to: .camel, separators: separators)
    }
    public static func pascalCaseDecoder(separators: SeparatorPolicy = .commonWithDot) -> JSONDecoder {
        decoder(from: .pascal, to: .camel, separators: separators)
    }
}

public protocol QuicklyEncodable: Encodable {}
public protocol QuicklyDecodable: Decodable {}

extension Data {
    public func toJSONString(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}

extension QuicklyEncodable {
    public func quickEncode(
        encodingStrategy: JSONEncoder.KeyEncodingStrategy = CustomStrategies.encodeCamelToSnake(),
        outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted
    ) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = encodingStrategy
            encoder.outputFormatting = outputFormatting
            let data = try encoder.encode(self)
            return data.toJSONString()
        } catch {
            print("Encoding failed with error: \(error)")
            return nil
        }
    }
}

extension QuicklyDecodable {
    public static func quickDecode(
        from jsonString: String,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy = CustomStrategies.decodeFromSnakeToCamel()
    ) -> Self? {
        do {
            guard let data = jsonString.data(using: .utf8) else { return nil }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = decodingStrategy
            return try decoder.decode(Self.self, from: data)
        } catch {
            print("Decoding failed with error: \(error)")
            return nil
        }
    }
}
