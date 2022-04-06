import Foundation
import UIKit
import FittedSheets

final class HourPickerBuilder {
    
    private init() {}
    
    static func make(hour: HourFieldModel?, callback: @escaping (HourFieldModel) -> Void) -> HourPickerViewController {
        let storyboard = UIStoryboard(name: "HourPicker", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HourPickerViewController") as! HourPickerViewController
        viewController.callback = callback
        viewController.hour = hour
        return viewController
    }
    
    static func makeBottomSheets(hour: HourFieldModel?, callback: @escaping (HourFieldModel) -> Void) -> SheetViewController {
        let viewController = HourPickerBuilder.make(hour: hour, callback: callback)
        
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
