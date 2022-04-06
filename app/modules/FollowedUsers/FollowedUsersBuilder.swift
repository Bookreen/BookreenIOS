import Foundation
import UIKit

final class FollowedUsersBuilder {
    
    private init() {
        
    }
    
    static func make() -> FollowedUsersViewController {
        let storyboard = UIStoryboard(name: "FollowedUsers", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FollowedUsersViewController") as! FollowedUsersViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = FollowedUsersViewModel(bookreenService: bookreenService)
        return viewController
    }
}
