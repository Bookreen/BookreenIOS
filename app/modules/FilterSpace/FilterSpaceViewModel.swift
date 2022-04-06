import Foundation

struct FilterOfficeOutput {
    let campusId: String?
    let campusTitle: String?
    let buildingId: String?
    let buildingTitle: String?
    let floorId: String?
    let floorTitle: String?
}

enum FilterSpaceResult {
    case openSearchFriend
    case changedOffice(FilterOfficeOutput)
}

struct FilterSpacePresenter {
    let campusId: String
    let campusTitle: String
    let buildingId: String
    let buildingTitle: String
    let floorId: String
    let floorTitle: String
}

enum FilterSpaceViewOutput {
    case ChangedActiveTag
}

protocol FilterSpaceViewModelDelegate: AnyObject {
    func handleOutput(_ output: FilterSpaceViewOutput)
}

protocol FilterSpaceViewModelProtocol: AnyObject {
    var activeTabTag: Int { get set }
    var presenter: FilterSpacePresenter { get set }
    var delegate: FilterSpaceViewModelDelegate? { get set }
    var filterOffice: FilterOfficeOutput { get set }
    func load()
}


final class FilterSpaceViewModel: FilterSpaceViewModelProtocol {
    
    var delegate: FilterSpaceViewModelDelegate?
    var presenter: FilterSpacePresenter
    var filterOffice: FilterOfficeOutput
    
    var activeTabTag: Int = 0 {
        didSet {
            self.delegate?.handleOutput(.ChangedActiveTag)
        }
    }
    
    init(presenter: FilterSpacePresenter) {
        self.activeTabTag = 0
        self.presenter = presenter
        self.filterOffice = FilterOfficeOutput(
            campusId: self.presenter.campusId,
            campusTitle: self.presenter.campusTitle,
            buildingId: self.presenter.buildingId,
            buildingTitle: self.presenter.buildingTitle,
            floorId: self.presenter.floorId,
            floorTitle: self.presenter.floorTitle
        )
    }
    
    func load() {
        if self.activeTabTag == 0 {
            self.activeTabTag = 1
        }
    }
}
