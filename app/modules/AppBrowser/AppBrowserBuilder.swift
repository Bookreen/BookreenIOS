import Foundation
import UIKit

final class AppBrowserBuilder {
    
    private init () {}
    
    static func make(screenTitle: String, urlAsString: String) -> AppBrowserViewController {
        let storyboard = UIStoryboard(name: "AppBrowser", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AppBrowserViewController") as! AppBrowserViewController
        viewController.urlAsString = urlAsString
        viewController.screenTitle = screenTitle
        return viewController
    }
}
