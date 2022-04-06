import Foundation
import UIKit


final class FilterMyOfficeBuilder {
    
    private init() {}
    
    static func make(presenter: FilterMyOfficePresenter) -> FilterMyOfficeViewController {
        let storyboard = UIStoryboard(name: "FilterMyOffice", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterMyOfficeViewController") as! FilterMyOfficeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = FilterMyOfficeViewModel(bookreenService: bookreenService, presenter: presenter)
        return viewController
    }
}
