import Foundation
import UIKit

final class ContactUsBuilder {
    
    private init() {}
    
    static func make() -> ContactUsViewController {
        let storyboard = UIStoryboard(name: "ContactUs", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = ContactUsViewModel(bookreenService: bookreenService)
        return viewController
    }
}
