import Foundation

enum SelectSpaceViewOutput {
     
}

protocol SelectSpaceViewModelProtocol: AnyObject {
    var delegate: SelectSpaceViewModelDelegate? { get set }
    var selectedSpace: ReservationSpaceModel? { get set }
    var planDate: String { get set }
    var startTime: String { get set }
    var endTime: String { get set }
    var spaceType:SpaceType {get set}
}

protocol SelectSpaceViewModelDelegate: AnyObject {
    func handleOutput(_ output: SelectSpaceViewOutput)
}

final class SelectSpaceViewModel: SelectSpaceViewModelProtocol {
    
    var selectedSpace: ReservationSpaceModel?
    var planDate: String
    var startTime: String
    var endTime: String
    var delegate: SelectSpaceViewModelDelegate?
    var spaceType: SpaceType
    
    init(selectedSpace: ReservationSpaceModel?, planDate: String, startTime: String, endTime: String,spaceType:SpaceType) {
        self.selectedSpace = selectedSpace
        self.planDate = planDate
        self.startTime = startTime
        self.endTime = endTime
        self.spaceType=spaceType
    }
}
