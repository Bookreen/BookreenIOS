import Foundation

public enum AppError: Error {
    case nullUrl
    case nullData
    case unauthorized
    case forbidden
    case unknownStatusCode
    case httpRequestError
    case serializationError(String)
    case httpResponseError(String)
    case nullFile
}
