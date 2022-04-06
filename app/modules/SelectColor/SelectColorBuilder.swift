import Foundation
import UIKit
import FittedSheets

final class SelectColorBuilder {
    
    private init() {}
    
    static func make(callback: @escaping (String) -> Void) -> SelectColorViewController {
        let storyboard = UIStoryboard(name: "SelectColor", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectColorViewController") as! SelectColorViewController
        viewController.viewModel = SelectColorViewModel()
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(callback: @escaping (String) -> Void) -> SheetViewController {
        let viewController = SelectColorBuilder.make(callback: callback)
        
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
