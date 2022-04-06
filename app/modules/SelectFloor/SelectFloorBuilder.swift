import Foundation
import UIKit
import FittedSheets

final class SelectFloorBuilder {
    
    private init() {}
    
    static func make(callback: @escaping(SelectFloorCallback) -> Void) -> SelectFloorViewController {
        let storyboard = UIStoryboard(name: "SelectFloor", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectFloorViewController") as! SelectFloorViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        
        viewController.callback = callback
        viewController.viewModel = SelectFloorViewModel(bookreenService: bookreenService)
        return viewController
    }
    
    static func makeBottomSheets(callback: @escaping(SelectFloorCallback) -> Void) -> SheetViewController {
        let viewController = SelectFloorBuilder.make(callback: callback)
        
        let options = SheetOptions(
            pullBarHeight: 0,
            presentingViewCornerRadius: 0,
            shouldExtendBackground: false,
            useFullScreenMode: false,
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: viewController, sizes: [.fullscreen], options: options)
        sheetController.view.backgroundColor = .clear
        sheetController.contentBackgroundColor = .clear
        return sheetController
    }
}

