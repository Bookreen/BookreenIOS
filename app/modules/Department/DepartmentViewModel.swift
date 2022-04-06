import Foundation

enum DepartmentViewOutput {
    case LoadedDepartment
    case ReloadList
}

protocol DepartmentViewModelDelegate: AnyObject {
    func handleOutput(_ output: DepartmentViewOutput)
}

protocol DepartmentViewModelProtocol: AnyObject {
    var delegate: DepartmentViewModelDelegate? { get set }
    var planDate: String { get set }
    var spaceGroup: SearchBookingResponse { get set }
    var spaceGroups: [SearchBookingResponse] { get set }
    var spaceType:SpaceType {get set}
    func load()
    func findSpace(_ spaceId: String) -> SpaceModel?
    func removeFavorite(space: SpaceModel)
    func addFavorite(space: SpaceModel)
}

final class DepartmentViewModel: DepartmentViewModelProtocol {
    
    var delegate: DepartmentViewModelDelegate?
    
    private let bookreenService: BookreenServiceProtocol
    
    var planDate: String
    var spaceGroup: SearchBookingResponse
    var spaceGroups: [SearchBookingResponse]
    var spaceType: SpaceType

    init(spaceType:SpaceType,bookreenService: BookreenServiceProtocol, planDate: String, spaceGroup: SearchBookingResponse, spaceGroups: [SearchBookingResponse]) {
        self.bookreenService = bookreenService
        self.planDate = planDate
        self.spaceGroup = spaceGroup
        self.spaceGroups = spaceGroups
        self.spaceType=spaceType
    }
    
    func load() {
        self.delegate?.handleOutput(.LoadedDepartment)
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
    
    func removeFavorite(space: SpaceModel) {
        let roomId = Int(space.id ?? "0") ?? 0
        let input = RemoveFavoriteInput(roomId: roomId)
        self.bookreenService.removeFavorite(input: input) { result in
            switch result {
            case .failure(_):
                self.delegate?.handleOutput(.ReloadList)
            case .success(_, _):
                (self.spaceGroup.occasions ?? []).forEach { item in
                    if item.id == space.id {
                        item.isMyFavorite = "false"
                    }
                }
                self.delegate?.handleOutput(.ReloadList)
            }
        }
    }
    
    func addFavorite(space: SpaceModel) {
        let roomId = Int(space.id ?? "0") ?? 0
        let input = AddFavoriteInput(roomId: roomId)
        self.bookreenService.addFavorite(input: input) { result in
            switch result {
            case .failure(_):
                self.delegate?.handleOutput(.ReloadList)
            case .success(_, _):
                (self.spaceGroup.occasions ?? []).forEach { item in
                    if item.id == space.id {
                        item.isMyFavorite = "true"
                    }
                }
                self.delegate?.handleOutput(.ReloadList)
            }
        }
    }
}
