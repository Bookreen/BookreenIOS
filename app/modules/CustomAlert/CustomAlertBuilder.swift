import Foundation
import UIKit
import FittedSheets

final class CustomAlertBuilder {
    
    private init() {}
    
    static func make(_ alertType: AlertType, message: String, buttonTitle: String, completion: (() -> Void)?) -> CustomAlertViewController {
        let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        viewController.alertType = alertType
        viewController.message = message
        viewController.buttonTitle = buttonTitle
        viewController.completion = completion
        return viewController
    }
    
    static func makeBottomSheets(_ alertType: AlertType, message: String, buttonTitle: String, completion: (() -> Void)?) -> SheetViewController {
        let alertViewController = CustomAlertBuilder.make(alertType, message: message, buttonTitle: buttonTitle, completion: completion)
        
        let options = SheetOptions(
            pullBarHeight: 0,
            presentingViewCornerRadius: 0,
            shouldExtendBackground: false,
            useFullScreenMode: false,
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: alertViewController, sizes: [.fullscreen], options: options)
        sheetController.view.backgroundColor = .clear
        sheetController.contentBackgroundColor = .clear
        return sheetController
    }
}
