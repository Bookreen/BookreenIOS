import Foundation
import UIKit

final class CustomTabBuilder {
    
    private init() {}
    
    static func make() -> CustomTabViewController {
        let storyboard = UIStoryboard(name: "CustomTab", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        return viewController
    }
}
