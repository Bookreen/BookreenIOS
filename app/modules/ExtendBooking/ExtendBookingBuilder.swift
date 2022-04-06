import Foundation
import UIKit
import FittedSheets

struct ExtendBookingOutput {
    let bookingModel: BookingModel
    let extendTime: Int
}

enum ExtendBookingViewOutput {
    case extendBooking(ExtendBookingOutput)
    case dismiss
}

final class ExtendBookingBuilder {
    
    private init() {}
    
    static func make(booking: BookingModel?, callback: @escaping(ExtendBookingViewOutput) -> Void) -> ExtendBookingViewController {
        let storyboard = UIStoryboard(name: "ExtendBooking", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ExtendBookingViewController") as! ExtendBookingViewController
        viewController.booking = booking
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(booking: BookingModel?, callback: @escaping(ExtendBookingViewOutput) -> Void) -> SheetViewController {
        let viewController = ExtendBookingBuilder.make(booking: booking, callback: callback)
        
        let options = SheetOptions(
            pullBarHeight: 0,
            presentingViewCornerRadius: 0,
            shouldExtendBackground: false,
            useFullScreenMode: false,
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: viewController, sizes: [.fullscreen], options: options)
        sheetController.dismissOnPull = false
        sheetController.allowPullingPastMaxHeight = false
        sheetController.view.backgroundColor = .clear
        sheetController.contentBackgroundColor = .clear
        return sheetController
    }
    
    
}


