import Foundation

enum SelectItemViewOutput {
    case LoadedItemList
    case showLoading(Bool)
}

protocol SelectItemViewModelProtocol: AnyObject {
    var list: [Item] { get set }
    var title: String { get set }
    var itemType: ItemType { get set }
    var campusList: [CampusModel] { get set }
    var buildingList: [BuildingModel] { get set }
    var floorList: [FloorModel] { get set }
    var presenter: SelectItemPresenter { get set }
    var delegate: SelectItemViewModelDelegate? { get set }
    func loadItemList()
}

protocol SelectItemViewModelDelegate: AnyObject {
    func handleOutput(_ output: SelectItemViewOutput)
}

final class SelectItemViewModel: SelectItemViewModelProtocol {
    
    var title: String
    var itemType: ItemType
    var presenter: SelectItemPresenter
    
    var campusList: [CampusModel] = []
    var buildingList: [BuildingModel] = []
    var floorList: [FloorModel] = []
    
    var list: [Item] = [] {
        didSet {
            self.delegate?.handleOutput(.LoadedItemList)
        }
    }
    var delegate: SelectItemViewModelDelegate?
    
    private let bookreenService: BookreenServiceProtocol
    
    init(title: String, itemType: ItemType, presenter: SelectItemPresenter, bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.title = title
        self.itemType = itemType
        self.presenter = presenter
        self.list = []
    }
    
    func loadItemList() {
        switch itemType {
        case .campus:
            self.fetchCampusList()
        case .building:
            self.fetchBuildingList()
        case .floor:
            self.fetchFloorList()
        }
    }
    
    private func fetchCampusList() {
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.getCampusList { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self.campusList = []
                self.list = []
            case .success(_, let campusList):
                self.campusList = campusList
                self.list = campusList.map { item in
                    return Item(id: item.id, title: item.name)
                }
            }
        }
    }
    
    private func fetchBuildingList() {
        self.delegate?.handleOutput(.showLoading(true))
        let campusId = self.presenter.campusId
        let input = GetBuildingListInput(campusId: campusId)
        self.bookreenService.getBuildingList(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self.buildingList = []
                self.list = []
            case .success(_, let buildingList):
                self.buildingList = buildingList
                self.list = buildingList.map { item in
                    return Item(id: item.id, title: item.name)
                }
            }
        }
    }
    
    private func fetchFloorList() {
        self.delegate?.handleOutput(.showLoading(true))
        let buildingId = self.presenter.buildingId
        let input = GetFloorListInput(buildingId: buildingId)
        self.bookreenService.getFloorList(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self.floorList = []
                self.list = []
            case .success(_, let floorList):
                self.floorList = floorList
                self.list = floorList.map { item in
                    return Item(id: item.id, title: item.name)
                }
            }
        }
    }
}
