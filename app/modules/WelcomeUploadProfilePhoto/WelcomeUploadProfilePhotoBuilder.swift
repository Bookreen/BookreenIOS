import Foundation
import UIKit

final class WelcomeUploadProfilePhotoBuilder {
    
    private init() {}
    
    static func make() -> WelcomeUploadProfilePhotoViewController {
        let storyboard = UIStoryboard(name: "WelcomeUploadProfilePhoto", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeUploadProfilePhotoViewController") as! WelcomeUploadProfilePhotoViewController
        
        return viewController
    }
}

