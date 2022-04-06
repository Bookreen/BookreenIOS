import Foundation
import UIKit

final class PersonsBuilder {
    
    private init() {
        
    }
    
    static func make() -> PersonsViewController {
        let storyboard = UIStoryboard(name: "Persons", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PersonsViewController") as! PersonsViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = PersonsViewModel(bookreenService: bookreenService)
        return viewController
    }
}
