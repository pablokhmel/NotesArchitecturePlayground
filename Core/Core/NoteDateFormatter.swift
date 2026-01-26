import Foundation

public class NoteDateFormatter {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, hh:mm"
        return formatter
    }()
    
    public init() {}
    
    public func createdDate(from date: Date) -> String {
        "Created: \(dateFormatter.string(from: date))"
    }
    
    public func updatedDate(from date: Date) -> String {
        "Updated: \(dateFormatter.string(from: date))"
    }
}
