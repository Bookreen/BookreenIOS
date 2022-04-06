import Foundation

enum ForgetPasswordViewOutput {
    case showLoading(Bool)
    case successSentEmail
    case errorSentEmail
    case isValidEmail(Bool)
}

protocol ForgetPasswordViewModelProtocol: AnyObject {
    var delegate: ForgetPasswordViewModelDelegate? { get set }
    func validEmail(_ email: String)
    func sendEmail(_ email: String)
}

protocol ForgetPasswordViewModelDelegate: AnyObject {
    func handleOutput(_ output: ForgetPasswordViewOutput)
}

final class ForgetPasswordViewModel: ForgetPasswordViewModelProtocol {
    
    private let authService: AuthServiceProtocol
    var delegate: ForgetPasswordViewModelDelegate?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func validEmail(_ email: String) {
        let isValid = email.isValidEmail()
        self.delegate?.handleOutput(.isValidEmail(isValid))
    }
    
    func sendEmail(_ email: String) {
        let input = ForgetPasswordInput(email: email)
        self.delegate?.handleOutput(.showLoading(true))
        self.authService.forgetPassword(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, let output):
                if output.forgotPasswordStatus {
                    self.delegate?.handleOutput(.successSentEmail)
                } else {
                    self.delegate?.handleOutput(.errorSentEmail)
                }
            case .failure(_):
                self.delegate?.handleOutput(.errorSentEmail)
            }
        }
    }
}
