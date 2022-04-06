import Foundation
import UIKit
import FittedSheets

enum StartBookingViewOutput {
    case startBooking(BookingModel)
    case dismiss
}

final class StartBookingBuilder {
    
    private init() {}
    
    static func make(booking: BookingModel, callback: @escaping(StartBookingViewOutput) -> Void) -> StartBookingViewController {
        let storyboard = UIStoryboard(name: "StartBooking", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "StartBookingViewController") as! StartBookingViewController
        viewController.booking = booking
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(booking: BookingModel, callback: @escaping(StartBookingViewOutput) -> Void) -> SheetViewController {
        let viewController = StartBookingBuilder.make(booking: booking, callback: callback)
        
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


