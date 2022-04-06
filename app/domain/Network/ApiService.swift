import Foundation
import Alamofire

public enum RequestBodyParameterType {
    case text
    case file
}

public struct RequestBodyParameter {
    let key: String
    let type: RequestBodyParameterType
    let value: String
}

public class ApiService {
    
    lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 90
        return Session(configuration: configuration)
    }()
    
    func generateMultiPartBody(boundary: String, parameters: [RequestBodyParameter]) throws -> Data? {
        var body = ""
        for param in parameters {
            let parameterName = param.key
            let parameterType = param.type
            let parameterValue = param.value
            
            if parameterType == .text {
                body += "\r\n\r\n\(parameterValue)\r\n"
            } else {
                let fileData = try NSData(contentsOfFile: parameterValue, options:[]) as Data
                let fileContent = String(data: fileData, encoding: .utf8)!
                body += "; filename=\"\(parameterValue)\"\r\n"
                  + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(parameterName)\""
            
        }
        body += "--\(boundary)--\r\n";
        return body.data(using: .utf8)
    }
    
    func generateUrlRequest(httpMethod: HttpMethodEnums, url: URL, parameters: [RequestBodyParameter]) throws -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try generateMultiPartBody(boundary: boundary, parameters: parameters)
        return request
    }
    
    func request(urlRequest: URLRequest, completion: @escaping (HttpRequestResult) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                Logger.shared.logInformation(message: error?.localizedDescription ?? "")
                completion(.failure(.httpRequestError))
                return
            }
            
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            switch responseCode {
            case 200:
                guard let data = data else {
                    Logger.shared.logInformation(message: "Data is null")
                    completion(.failure(.nullData))
                    return
                }
                
                completion(.success(data))
            case 201:
                guard let data = data else {
                    Logger.shared.logInformation(message: "Data is null")
                    completion(.failure(.nullData))
                    return
                }
                
                completion(.success(data))
            case 400:
                guard let data = data else {
                    Logger.shared.logInformation(message: "Data is null")
                    completion(.failure(.nullData))
                    return
                }
                
                completion(.success(data))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            default:
                completion(.failure(.unknownStatusCode))
            }
        }
        dataTask.resume()
    }
}

