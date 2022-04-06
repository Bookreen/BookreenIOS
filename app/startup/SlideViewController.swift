import Foundation
import UIKit

protocol SlideViewControllerProtocol: AnyObject {
    var delegate: SlideViewControllerDelegate? { get set }
}

protocol SlideViewControllerDelegate: AnyObject {
    func onChangeOffice(campus: CampusModel?, building: BuildingModel?, floor: FloorModel?)
    func onChangeProfilePhoto(image: UIImage)
}

class SlideViewController: AppViewController, SlideViewControllerProtocol {
    var delegate: SlideViewControllerDelegate?
    var index: Int = 0
}
