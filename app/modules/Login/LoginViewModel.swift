import Foundation

enum LoginViewOutput {
    case showLoading(Bool)
    case isValidInput(Bool)
    case successLoginAndNavigateWelcome
    case successLoginAndNavigateHome
    case successLoginAndNavigatePrivacyPolicy(UserModel)
    case failureLogin
    case handleError(Error)
}

protocol LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate? { get set }
    func validInputs(username: String, password: String)
    func login(username: String, password: String)
}

protocol LoginViewModelDelegate {
    func handleOutput(_ output: LoginViewOutput)
}

final class LoginViewModel: LoginViewModelProtocol {
    
    var delegate: LoginViewModelDelegate?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func validInputs(username: String, password: String) {
        let isValid = !username.isEmpty && !password.isEmpty
        self.delegate?.handleOutput(.isValidInput(isValid))
    }
    
    func login(username: String, password: String) {
        self.delegate?.handleOutput(.showLoading(true))
        let input = LoginInput(username: username, password: password)
        self.authService.login(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, let output):
                SessionManager.shared.username = username
                SessionManager.shared.password = password
                if let user = output.user, let company = output.company {
                    let department = output.department
                    SessionManager.shared.setUser(user)
                    SessionManager.shared.setCompany(company)
                    SessionManager.shared.setDepartment(department)
                    if user.isKvkkConfirmation() {
                        if user.isExistsMyOffice() {
                            self.delegate?.handleOutput(.successLoginAndNavigateHome)
                        } else {
                            self.delegate?.handleOutput(.successLoginAndNavigateWelcome)
                        }
                    } else {
                        self.delegate?.handleOutput(.successLoginAndNavigatePrivacyPolicy(user))
                    }
                } else {
                    self.delegate?.handleOutput(.failureLogin)
                }
            case .failure(let error):
                self.delegate?.handleOutput(.handleError(error))
            }
        }
    }
}
