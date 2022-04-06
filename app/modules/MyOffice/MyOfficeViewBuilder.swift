import Foundation
import UIKit

final class MyOfficeViewBuilder {
    
    private init() {}
    
    static func make() -> MyOfficeViewController {
        let storyboard = UIStoryboard(name: "MyOffice", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyOfficeViewController") as! MyOfficeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = MyOfficeViewModel(bookreenService: bookreenService)
        return viewController
    }
}

