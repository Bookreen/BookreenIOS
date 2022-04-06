import Foundation
import UIKit

final class CalendarBuilder {
    
    private init() {}
    
    static func make() -> CalendarViewController {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = CalendarViewModel(bookreenService: bookreenService)
        return viewController
    }
}
