import Foundation
import UIKit

final class WelcomeBuilder {
    
    private init() {}
    
    static func make() -> WelcomeViewController {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = WelcomeViewModel(bookreenService: bookreenService)
        return viewController
    }
}
