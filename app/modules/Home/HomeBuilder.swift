import Foundation
import UIKit

final class HomeBuilder {
    
    private init() {}
    
    static func make() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        let openWeatherMapService = OpenWeatherMapService()
        viewController.viewModel = HomeViewModel(bookreenService: bookreenService, openWeatherMapService: openWeatherMapService)
        return viewController
    }
}
