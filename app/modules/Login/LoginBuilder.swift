import Foundation
import UIKit

final class LoginBuilder {
    
    private init() {}
    
    static func make() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let token = SessionManager.shared.token
        let authService = AuthService(token: token)
        viewController.viewModel = LoginViewModel(authService: authService)
        return viewController
    }
}
