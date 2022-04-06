import Foundation
import UIKit
import FittedSheets

final class DatePickerBuilder {
    
    private init() {}
    
    static func make(officeDays: [Int], date: DateFieldModel?, callback: @escaping (DateFieldModel) -> Void) -> DatePickerViewController {
        let storyboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let generatedDate = formatter.date(from: "\(date.year)-\(date.month)-\(date.day)")
            viewController.date = generatedDate
            viewController.officeDays = officeDays
        }
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(officeDays: [Int], date: DateFieldModel?, callback: @escaping (DateFieldModel) -> Void) -> SheetViewController {
        let viewController = DatePickerBuilder.make(officeDays: officeDays, date: date, callback: callback)
        
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
