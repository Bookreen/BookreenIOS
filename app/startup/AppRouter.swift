import Foundation
import UIKit

class AppRouter {
    
    func start(_ window: UIWindow) {
        let viewController = SplashBuilder.make()
        let navigationViewController = ApplicationNavigationController(rootViewController: viewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
