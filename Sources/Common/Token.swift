public enum Token: Equatable {
    case whitespace
    case keyword(Keyword)
    case symbol(String)
    case stringConstant(String)
    case integerConstant(Int16)
    case identifier(String)
    case comment(String)
}
