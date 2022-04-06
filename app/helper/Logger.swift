import Foundation

public class Logger {

    public static let shared = Logger()
    
    private init() {}
    
    public func logInformation(message: String, tag: String = "Bookreen") {
        print("\(tag): \(message)")
    }
    
    public func logError(message: String, error: Error, tag: String = "Bookreen") {
        print("\(tag): \(message) -> error: \(error.localizedDescription)")
    }
    
}
