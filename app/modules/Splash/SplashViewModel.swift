import Foundation

enum SplashViewOutput {
    case successLoginAndNavigateHome
    case successLoginAndNavigateWelcome
    case failureLogin
    case handleError(Error)
}

protocol SplashViewModelProtocol {
    var delegate: SplashViewModelDelegate? { get set }
    func validInputs(username: String, password: String) -> Bool
    func login()
}

protocol SplashViewModelDelegate {
    func handleOutput(_ output: SplashViewOutput)
}

final class SplashViewModel: SplashViewModelProtocol {
    
    var delegate: SplashViewModelDelegate?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func validInputs(username: String, password: String) -> Bool {
        let isValid = !username.isEmpty && !password.isEmpty
        return isValid
    }
    
    func login() {
        let username: String = SessionManager.shared.username
        let password: String = SessionManager.shared.password
        
        
        if !self.validInputs(username: username, password: password) {
            self.delegate?.handleOutput(.failureLogin)
            return
        }
        
        let input = LoginInput(username: username, password: password)
        
        self.authService.login(input: input) { result in
            switch result {
            case .success(_, let output):
                SessionManager.shared.username = username
                SessionManager.shared.password = password
                if let user = output.user, let company = output.company {
                    let department = output.department
                    SessionManager.shared.setUser(user)
                    SessionManager.shared.setCompany(company)
                    SessionManager.shared.setDepartment(department)
                    SessionManager.shared.setDisplaySettings(output.displaySettings)
                    if !user.isKvkkConfirmation() {
                        self.delegate?.handleOutput(.failureLogin)
                    } else {
                        if user.isExistsMyOffice() {
                            self.delegate?.handleOutput(.successLoginAndNavigateHome)
                        } else {
                            self.delegate?.handleOutput(.successLoginAndNavigateWelcome)
                        }
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
