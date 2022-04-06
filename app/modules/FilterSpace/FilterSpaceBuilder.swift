import Foundation
import UIKit
import FittedSheets

final class FilterSpaceBuilder {
    
    private init() {}
    
    static func make(presenter: FilterSpacePresenter, callback: @escaping (FilterSpaceResult) -> Void) -> FilterSpaceViewController {
        let storyboard = UIStoryboard(name: "FilterSpace", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterSpaceViewController") as! FilterSpaceViewController
        
        viewController.viewModel = FilterSpaceViewModel(presenter: presenter)
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(presenter: FilterSpacePresenter, callback: @escaping (FilterSpaceResult) -> Void) -> SheetViewController {
        let viewController = FilterSpaceBuilder.make(presenter: presenter, callback: callback)
        
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



