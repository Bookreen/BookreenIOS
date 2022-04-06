import Foundation

struct InstantBookingOutput {
    let space: SpaceModel
    let time: Int
}

enum InstantBookingViewOutput {
    case createReservation(InstantBookingOutput)
    case dismiss
}

protocol InstantBookingViewModelProtocol: AnyObject {
    var delegate: InstantBookingViewModelDelegate? { get set }
}

protocol InstantBookingViewModelDelegate: AnyObject {
    func handleOutput(_ output: InstantBookingViewOutput)
}

final class InstantBookingViewModel: InstantBookingViewModelProtocol {
    
    var delegate: InstantBookingViewModelDelegate?
}
