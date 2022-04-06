import Foundation
import UIKit
import FittedSheets


final class SelectSeatingArrangementBuilder {
    
    private init() {}
    
    static func make(layoutId: Int, callback: @escaping (Int) -> Void) -> SelectSeatingArrangementViewController {
        let storyboard = UIStoryboard(name: "SelectSeatingArrangement", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectSeatingArrangementViewController") as! SelectSeatingArrangementViewController
        viewController.callback = callback
        viewController.type = layoutId
        return viewController
    }
    
    static func makeBottomSheets(layoutId: Int, callback: @escaping (Int) -> Void) -> SheetViewController {
        let viewController = SelectSeatingArrangementBuilder.make(layoutId: layoutId, callback: callback)
        
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



