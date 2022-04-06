//
//  FilterMyOfficeViewModel.swift
import Foundation

struct FilterMyOfficePresenter {
    let campusId: String
    let campusTitle: String
    let buildingId: String
    let buildingTitle: String
    let floorId: String
    let floorTitle: String
}

enum FilterMyOfficeViewOutput {
    case showLoading(Bool)
    case successGetCampusList
    case successGetBuildingList
    case successGetFloorList
    case handleError(Error)
}

protocol FilterMyOfficeViewModelProtocol: AnyObject {
    var delegate: FilterMyOfficeViewModelDelegate? { get set }
    var presenter: FilterMyOfficePresenter { get set }
    var selectedCampus: CampusModel? { get set }
    var selectedBuilding: BuildingModel? { get set }
    var selectedFloor: FloorModel? { get set }
    var campusList: [CampusModel] { get set }
    var buildingList: [BuildingModel] { get set }
    var floorList: [FloorModel] { get set }
    func getCampusList()
    func getBuildingList(campusId: String)
    func getFloorList(buildingId: String)
}

protocol FilterMyOfficeViewModelDelegate: AnyObject {
    func handleOutput(_ output: FilterMyOfficeViewOutput)
}

final class FilterMyOfficeViewModel: FilterMyOfficeViewModelProtocol {
    
    var delegate: FilterMyOfficeViewModelDelegate?
    var presenter: FilterMyOfficePresenter
    
    var selectedCampus: CampusModel? = nil {
        didSet {
            let campusId = self.selectedCampus?.id ?? ""
            self.getBuildingList(campusId: campusId)
            self.selectedBuilding = nil
        }
    }
    
    var selectedBuilding: BuildingModel? = nil {
        didSet {
            let buildingId = self.selectedBuilding?.id ?? ""
            self.getFloorList(buildingId: buildingId)
            self.selectedFloor = nil
        }
    }
    var selectedFloor: FloorModel? = nil
    
    var campusList: [CampusModel]
    var buildingList: [BuildingModel]
    var floorList: [FloorModel]
    
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol, presenter: FilterMyOfficePresenter) {
        self.presenter = presenter
        self.bookreenService = bookreenService
        self.campusList = []
        self.buildingList = []
        self.floorList = []
    }
    
    func getCampusList() {
        self.bookreenService.getCampusList { result in
            switch result {
            case .success(_, let _campusList):
                self.campusList = _campusList
                self.delegate?.handleOutput(.successGetCampusList)
            case .failure(_):
                self.campusList = []
                self.delegate?.handleOutput(.successGetCampusList)
            }
        }
    }
    
    func getBuildingList(campusId: String) {
        self.buildingList = []
        let input = GetBuildingListInput(campusId: campusId)
        self.bookreenService.getBuildingList(input: input) { result in
            switch result {
            case .success(_, let _buildingList):
                self.buildingList = _buildingList
                self.buildingList.forEach { item in
                    if item.id == self.presenter.buildingId {
                        self.selectedBuilding = item
                    }
                }
                self.delegate?.handleOutput(.successGetBuildingList)
            case .failure(_):
                self.buildingList = []
                self.delegate?.handleOutput(.successGetBuildingList)
            }
        }
    }
    
    func getFloorList(buildingId: String) {
        self.floorList = []
        let input = GetFloorListInput(buildingId: buildingId)
        self.bookreenService.getFloorList(input: input) { result in
            switch result {
            case .success(_, let _floorList):
                self.floorList = _floorList
                self.delegate?.handleOutput(.successGetFloorList)
            case .failure(_):
                self.floorList = []
                self.delegate?.handleOutput(.successGetFloorList)
            }
        }
    }
}
