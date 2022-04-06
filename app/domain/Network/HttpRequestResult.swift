import Foundation

public enum HttpRequestResult {
    case success(Data)
    case failure(AppError)
}
