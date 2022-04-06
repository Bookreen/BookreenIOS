import Foundation
import UIKit

final class SpaceListBuilder {
    
    private init() {}
    
    static func make(spaceType:SpaceType,presenter: SpaceListViewPresenter, callback: @escaping (ReservationSpaceModel) -> Void) -> SpaceListViewController {
        let storyboard = UIStoryboard(name: "SpaceList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SpaceListViewController") as! SpaceListViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = SpaceListViewModel(bookreenService: bookreenService, presenter: presenter,spaceType: spaceType)
        viewController.callback = callback
        return viewController
    }
}
