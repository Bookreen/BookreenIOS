import Foundation
import UIKit


final class FilterSelectOfficeBuilder {
    
    private init() {}
    
    static func make(presenter: FilterSelectOfficePresenter) -> FilterSelectOfficeViewController {
        let storyboard = UIStoryboard(name: "FilterSelectOffice", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterSelectOfficeViewController") as! FilterSelectOfficeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = FilterSelectOfficeViewModel(bookreenService: bookreenService, presenter: presenter)
        return viewController
    }
}




