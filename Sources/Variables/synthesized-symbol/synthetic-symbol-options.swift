import Primitives

public struct SyntheticSymbolOptions: Sendable {
    public var suffix: SynthesizedSymbol
    public var casing: Casing
    public var infix: String?
    public var formatting: KeyFormattingStrategy

    public init(
        suffix: SynthesizedSymbol = .api_key,
        casing: Casing = .snake,
        infix: String? = "_",
        formatting: KeyFormattingStrategy = .uppercased
    ) {
        self.suffix = suffix
        self.casing = casing
        self.infix = infix
        self.formatting = formatting
    }
}
