import Foundation

struct FloorPlanViewPresenter {
    let planDate: String
    let startTime: String
    let endTime: String
    let selectedSpace: ReservationSpaceModel?
}

enum FloorPlanViewOutput {
    case LoadedDesks
}

protocol FloorPlanViewModelProtocol: AnyObject {
    var delegate: FloorPlanViewModelDelegate? { get set }
    var presenter: FloorPlanViewPresenter {get set}
    var spaceGroups: [SearchBookingResponse] { get set }
    var selectedSpace: SpaceModel? { get set }
    var spaceType : SpaceType {get set}
    func loadDesks()
    func findSpace(_ spaceId: String) -> SpaceModel?
}

protocol FloorPlanViewModelDelegate: AnyObject {
    func handleOutput(_ output: FloorPlanViewOutput)
}

final class FloorPlanViewModel: FloorPlanViewModelProtocol {
    
    var delegate: FloorPlanViewModelDelegate?
    var spaceGroups: [SearchBookingResponse]
    private let bookreenService: BookreenServiceProtocol!
    var presenter: FloorPlanViewPresenter
    var selectedSpace: SpaceModel?
    var spaceType: SpaceType
    init(spaceType:SpaceType,bookreenService: BookreenServiceProtocol, presenter: FloorPlanViewPresenter) {
        self.bookreenService = bookreenService
        self.presenter = presenter
        self.spaceGroups = []
        self.spaceType=spaceType
    }
    
    func findSpace(_ spaceId: String) -> SpaceModel? {
        var spaceModel: SpaceModel? = nil
        self.spaceGroups.forEach { item in
            (item.occasions ?? []).forEach { space in
                if space.id == spaceId {
                    spaceModel = space
                }
            }
        }
        return spaceModel
    }
    
    func loadDesks() {
        let selectedSpace = self.presenter.selectedSpace
        let planDate = self.presenter.planDate
        let startTime = self.presenter.startTime
        let endTime = self.presenter.endTime
        
        let campusId = selectedSpace?.campusId ?? ""
        let buildingId = selectedSpace?.buildingId ?? ""
        let floorId = selectedSpace?.floorId ?? ""
        
        let office = SearchBookingOfficeInput(campusID: campusId, buildingID: buildingId, floorID: floorId)
        let input = SearchBookingInput(
            isInDepartment: false,
            office: office,
            locationType: "3",
            layoutID: "0",
            equipmentIDs: [],
            capacity: "0",
            planDate: planDate,
            sTime: startTime,
            eTime: endTime
        )
        self.bookreenService.searchBooking(input: input) { result in
            switch result {
            case .failure(_):
                self.spaceGroups = []
            case .success(_, let response):
                self.spaceGroups = response
            }
            self.delegate?.handleOutput(.LoadedDesks)
        }
    }
}
