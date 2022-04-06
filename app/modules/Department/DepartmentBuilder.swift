import Foundation
import UIKit

final class DepartmentBuilder {
    
    private init() {}
    
    static func make(spaceType:SpaceType,planDate: String, spaceGroup: SearchBookingResponse, spaceGroups: [SearchBookingResponse], callback: @escaping (SpaceModel) -> Void) -> DepartmentViewController {
        let storyboard = UIStoryboard(name: "Department", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DepartmentViewController") as! DepartmentViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = DepartmentViewModel(spaceType:spaceType,bookreenService: bookreenService, planDate: planDate, spaceGroup: spaceGroup, spaceGroups: spaceGroups)
        viewController.callback = callback
        return viewController
    }
}



