import Primitives

public enum SynthesizedSymbol: String, RawRepresentable, Sendable, Codable {
    case app_name
    case api_key
    case token
    case bearer
    case public_key_path
    case private_key_path
    case db_name
    case db_user
    case db_passwd
    case webhook_url

    public static func synthesize(
        name: String,
        using options: SyntheticSymbolOptions
    ) -> String {
        var res: [String] = [name]

        if let infix = options.infix {
            res.append(infix)
        }

        res.append(options.suffix.rawValue)
        let joined = res.joined()
        let styled = joined.casing.as(
            options.casing
        )
        let formatted = options.formatting.apply(styled)
        return formatted
    }

    public static func synthesize(
        name: String?,
        using options: SyntheticSymbolOptions
    ) throws -> String {
        guard let name else {
            throw SyntheticSymbolError.nameIsEmpty
        }

        return synthesize(
            name: name,
            using: options
        )
    }

    public func synthesize(
        name: String
    ) -> String {
        var options = SyntheticSymbolOptions()
        options.suffix = self

        return Self.synthesize(
            name: name,
            using: options
        )
    }

    public static func synthesize(
        name: String,
        suffix: SynthesizedSymbol
    ) -> String {
        suffix.synthesize(
            name: name
        )
    }
}
