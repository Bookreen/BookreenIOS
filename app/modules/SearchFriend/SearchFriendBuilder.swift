import Foundation
import UIKit

final class SearchFriendBuilder {
    
    private init() {}
    
    static func make(_ select:Bool=false,callback: @escaping (BookingModel) -> Void, selectCallback:((ParticipantModel)->Void)?=nil) -> SearchFriendViewController {
        let storyboard = UIStoryboard(name: "SearchFriend", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchFriendViewController") as! SearchFriendViewController

        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = SearchFriendViewModel(bookreenService: bookreenService)
        viewController.justSelect=select
        viewController.callback = callback
        viewController.selectCallback=selectCallback
        return viewController
    }
}

