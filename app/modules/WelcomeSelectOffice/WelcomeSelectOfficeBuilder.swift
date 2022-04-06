import Foundation
import UIKit

final class WelcomeSelectOfficeBuilder {
    
    private init() {}
    
    static func make() -> WelcomeSelectOfficeViewController {
        let storyboard = UIStoryboard(name: "WelcomeSelectOffice", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeSelectOfficeViewController") as! WelcomeSelectOfficeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = WelcomeSelectOfficeViewModel(bookreenService: bookreenService)
        return viewController
    }
}
