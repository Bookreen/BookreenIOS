import Foundation
import UIKit

final class FloorPlanBuilder {
    
    private init() {}
    
    static func make(spaceType:SpaceType,presenter: FloorPlanViewPresenter, callback: @escaping (ReservationSpaceModel) -> Void) -> FloorPlanViewController {
        let storyboard = UIStoryboard(name: "FloorPlan", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FloorPlanViewController") as! FloorPlanViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = FloorPlanViewModel(spaceType:spaceType,bookreenService: bookreenService, presenter: presenter)
        viewController.callback = callback
        
        return viewController
    }
}
