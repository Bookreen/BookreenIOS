import Foundation
import UIKit

final class NewOfficeReservationBuilder {
    
    private init() {}
    
    static func make(_ booking:BookingModel?=nil) -> NewOfficeReservationViewController {
        let storyboard = UIStoryboard(name: "NewOfficeReservation", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewOfficeReservationViewController") as! NewOfficeReservationViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        viewController.viewModel = NewOfficeReservationViewModel(bookreenService: bookreenService,booking: booking)
        return viewController
    }
}
