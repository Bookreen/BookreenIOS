import Foundation

public enum RestApiServiceResult<Value> {
    case success(String, Value)
    case failure(Swift.Error)
}
