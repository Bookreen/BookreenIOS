import Foundation
import UIKit
import FittedSheets

enum CancelBookingViewOutput {
    case cancelBooking(BookingModel)
    case dismiss
}

final class CancelBookingBuilder {
    
    private init() {}
    
    static func make(booking: BookingModel, callback: @escaping(CancelBookingViewOutput) -> Void) -> CancelBookingViewController {
        let storyboard = UIStoryboard(name: "CancelBooking", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CancelBookingViewController") as! CancelBookingViewController
        viewController.booking = booking
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(booking: BookingModel, callback: @escaping(CancelBookingViewOutput) -> Void) -> SheetViewController {
        let viewController = CancelBookingBuilder.make(booking: booking, callback: callback)
        
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


