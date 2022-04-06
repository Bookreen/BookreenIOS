import Foundation
import UIKit
import FittedSheets

enum EndBookingViewOutput {
    case endBooking(BookingModel)
    case dismiss
}

final class EndBookingBuilder {
    
    private init() {}
    
    static func make(booking: BookingModel, callback: @escaping(EndBookingViewOutput) -> Void) -> EndBookingViewController {
        let storyboard = UIStoryboard(name: "EndBooking", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EndBookingViewController") as! EndBookingViewController
        viewController.booking = booking
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(booking: BookingModel, callback: @escaping(EndBookingViewOutput) -> Void) -> SheetViewController {
        let viewController = EndBookingBuilder.make(booking: booking, callback: callback)
        
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


