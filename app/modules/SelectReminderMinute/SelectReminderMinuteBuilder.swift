import Foundation
import UIKit
import FittedSheets

final class SelectReminderMinuteBuilder {
    
    private init() {}
    
    static func make(reminder: Int, callback: @escaping (Int) -> Void) -> SelectReminderMinuteViewController {
        let storyboard = UIStoryboard(name: "SelectReminderMinute", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectReminderMinuteViewController") as! SelectReminderMinuteViewController
        viewController.callback = callback
        viewController.reminder = reminder
        return viewController
    }
    
    static func makeBottomSheets(reminder: Int, callback: @escaping (Int) -> Void) -> SheetViewController {
        let viewController = SelectReminderMinuteBuilder.make(reminder: reminder, callback: callback)
        
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

