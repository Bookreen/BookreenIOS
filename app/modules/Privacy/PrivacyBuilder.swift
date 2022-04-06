import Foundation
import UIKit

final class PrivacyBuilder {
    
    private init() {}
    
    static func make(user:UserModel) -> PrivacyViewController {
        let storyboard = UIStoryboard(name: "Privacy", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        let viewModel = PrivacyViewModel(user:user,bookreenService: bookreenService)
        viewController.viewModel = viewModel
        return viewController
    }
}

