import Foundation
import UIKit

final class ProfileBuilder {
    
    private init() {}
    
    static func make() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        let token = SessionManager.shared.token
        let authService = AuthService(token: token)
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = ProfileViewModel(bookreenService: bookreenService, authService: authService)
        return viewController
    }
}
