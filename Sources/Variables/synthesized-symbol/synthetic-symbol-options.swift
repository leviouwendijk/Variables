public struct SyntheticSymbolOptions: Sendable {
    // public var name: String
    public var suffix: SynthesizedSymbol
    public var style: CaseStyle
    public var infix: String?
    public var formatting: KeyFormattingStrategy
    
    public init(
        // name: String,
        suffix: SynthesizedSymbol = .api_key,
        style: CaseStyle = .snake,
        infix: String? = "_",
        formatting: KeyFormattingStrategy = .uppercased
    ) {
        // self.name = name
        self.suffix = suffix
        self.style = style
        self.infix = infix
        self.formatting = formatting
    }
}
