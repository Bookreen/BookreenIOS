import Foundation
import UIKit

final class SelectSpaceBuilder {
    
    private init() {}
    
    static func make(spaceType:SpaceType,selectedSpace: ReservationSpaceModel?, planDate: String, startTime: String, endTime: String, callback: @escaping (ReservationSpaceModel) -> Void) -> SelectSpaceViewController {
        let storyboard = UIStoryboard(name: "SelectSpace", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectSpaceViewController") as! SelectSpaceViewController
        viewController.viewModel = SelectSpaceViewModel(selectedSpace: selectedSpace, planDate: planDate, startTime: startTime, endTime: endTime, spaceType: spaceType)
        viewController.callback = callback
        return viewController
    }
}

