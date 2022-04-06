import Foundation
import Alamofire

struct LoginInput: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case username = "LoginName"
        case password = "Password"
    }
    
    let username: String
    let password: String
}

struct LoginOutput: Decodable {
    public enum CodingKeys: String, CodingKey {
        case user = "User"
        case company = "Company"
        case department = "Department"
        case message = "message"
        case displaySettings="DisplaySettings"
    }
    
    let message: String?
    let user: UserModel?
    let company: CompanyModel?
    let department: DepartmentModel?
    let displaySettings:DisplaySettings?
}

struct ForgetPasswordInput: Encodable {
    public enum CodingKeys: String, CodingKey {
        case email = "email"
    }
    
    let email: String
}

struct ForgetPasswordOutput: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case verifiedUserStatus = "VerifiedUserStatus"
        case forgotPasswordStatus = "ForgotPasswordStatus"
    }
    
    let verifiedUserStatus: Bool
    let forgotPasswordStatus: Bool
}

struct LogoutOutput {}

protocol AuthServiceProtocol: AnyObject {
    func login(input: LoginInput, completion: @escaping (RestApiServiceResult<LoginOutput>) -> Void)
    func forgetPassword(input: ForgetPasswordInput, completion: @escaping (RestApiServiceResult<ForgetPasswordOutput>) -> Void)
    func logout(completion: @escaping (RestApiServiceResult<LogoutOutput>) -> Void)
}

final class AuthService: ApiService, AuthServiceProtocol {
    
    private let token: String
    init(token: String) {
        self.token = token
    }
    
    func login(input: LoginInput, completion: @escaping (RestApiServiceResult<LoginOutput>) -> Void) {
        let urlAsString = "\(baseUrl)\(AuthEndpoint.login)"
        let parameters: [String: String] = [
            "LoginName": input.username,
            "Password": input.password
        ]
        
        
        
        self.sessionManager.request(urlAsString, method: .post, parameters: parameters).response { response in
            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.request?.url
            {
                if let oldCookies = self.sessionManager.session.configuration.httpCookieStorage?.cookies {
                    for oldCookie in oldCookies {
                        self.sessionManager.session.configuration.httpCookieStorage?.deleteCookie(oldCookie)
                    }
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                for cookie in cookies {
                    self.sessionManager.session.configuration.httpCookieStorage?.setCookie(cookie)
                }
            }
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(LoginOutput.self, from: _data)
                    completion(.success("", apiResponse))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func forgetPassword(input: ForgetPasswordInput, completion: @escaping (RestApiServiceResult<ForgetPasswordOutput>) -> Void) {
        let urlAsString = AuthEndpoint.forgotPassword(token: self.token, email: input.email)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(ForgetPasswordOutput.self, from: _data)
                    completion(.success("", apiResponse))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (RestApiServiceResult<LogoutOutput>) -> Void) {
        let urlAsString = AuthEndpoint.logout(token: self.token)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(_):
                completion(.success("", LogoutOutput()))
            case .failure(let error):
                print(error)
                completion(.success("", LogoutOutput()))
            }
        }
    }
}
