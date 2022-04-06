import Foundation
import UIKit

final class PreviewFloorBuilder {
    
    private init() {}
    
    static func make() -> PreviewFloorViewController {
        let storyboard = UIStoryboard(name: "PreviewFloor", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PreviewFloorViewController") as! PreviewFloorViewController
        return viewController
    }
}
