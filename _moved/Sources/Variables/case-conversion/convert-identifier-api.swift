public func convertIdentifier(
    _ input: String,
    to style: CaseStyle,
    separators: SeparatorPolicy = .commonWithDot
) -> String {
    let parts = tokenizeIdentifier(input, separators: separators)
    if parts.isEmpty { return input }

    switch style {
    case .snake:
        return parts.map { lowerASCII($0) }.joined(separator: "_")

    case .camel:
        let head = lowerASCII(parts[0])
        if parts.count == 1 { return head }
        let tail = parts.dropFirst().map { upperFirstLowerRestASCII($0) }.joined()
        return head + tail

    case .pascal:
        return parts.map { pascalizePreservingAfterPunct($0) }.joined()
    }
}

// Back-compat functions (now forwarded to the core)
/// camelCase → snake_case
public func convertToSnakeCase(_ input: String) -> String {
    convertIdentifier(input, to: .snake)
}

/// snake_case → camelCase
public func convertToCamelCase(_ input: String) -> String {
    // We don't assume the source is snake; we just tokenize & rebuild camel.
    convertIdentifier(input, to: .camel)
}

/// anything → PascalCase
public func convertToPascalCase(_ input: String) -> String {
    convertIdentifier(input, to: .pascal)
}

// Overloads allowing explicit separator policy
public func convertToSnakeCase(_ input: String, separators: SeparatorPolicy) -> String {
    convertIdentifier(input, to: .snake, separators: separators)
}

public func convertToCamelCase(_ input: String, separators: SeparatorPolicy) -> String {
    convertIdentifier(input, to: .camel, separators: separators)
}

public func convertToPascalCase(_ input: String, separators: SeparatorPolicy) -> String {
    convertIdentifier(input, to: .pascal, separators: separators)
}

extension String {
    public func snake() -> String  { convertIdentifier(self, to: .snake) }
    public func camel() -> String  { convertIdentifier(self, to: .camel) }
    public func pascal() -> String { convertIdentifier(self, to: .pascal) }
}

public protocol CaseConvertible {
    func snake() -> String
    func camel() -> String
    func pascal() -> String
}

extension CaseConvertible where Self: RawRepresentable, Self.RawValue == String {
    public func snake() -> String { rawValue.snake() }
    public func camel() -> String { rawValue.camel() }
    public func pascal() -> String { rawValue.pascal() }
}
