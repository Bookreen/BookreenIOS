import Foundation
import UIKit

final class SplashBuilder {
    
    private init() {}
    
    static func make() -> SplashViewController {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        let token = SessionManager.shared.token
        let authService = AuthService(token: token)
        viewController.viewModel = SplashViewModel(authService: authService)
        return viewController
    }
}
