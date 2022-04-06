import Foundation
import UIKit
import FittedSheets

final class InstantBookingBuilder {
    
    private init() {}
    
    static func make(space: SpaceModel, callback: @escaping(InstantBookingViewOutput) -> Void) -> InstantBookingViewController {
        let storyboard = UIStoryboard(name: "InstantBooking", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InstantBookingViewController") as! InstantBookingViewController
        
        viewController.space = space
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(space: SpaceModel, callback: @escaping(InstantBookingViewOutput) -> Void) -> SheetViewController {
        let viewController = InstantBookingBuilder.make(space: space, callback: callback)
        
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

