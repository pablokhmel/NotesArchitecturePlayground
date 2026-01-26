public enum ValidationError: Error {
    case nameEmpty
    case nameTooShort(min: Int)
    case noteEmpty
    case noteTooShort(min: Int)
    
    public var message: String {
        switch self {
        case .nameEmpty:
            return "Name cannot be empty"
        case .nameTooShort(let min):
            return "Name must be at least \(min) characters"
        case .noteEmpty:
            return "Note cannot be empty"
        case .noteTooShort(let min):
            return "Note must be at least \(min) characters"
        }
    }
}
