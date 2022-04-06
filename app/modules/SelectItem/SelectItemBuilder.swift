import Foundation
import UIKit
import FittedSheets

enum ItemType {
    case campus
    case building
    case floor
}

struct SelectItemResult {
    let itemType: ItemType
    let campus: CampusModel?
    let building: BuildingModel?
    let floor: FloorModel?
}

struct SelectItemPresenter {
    let campusId: String
    let buildingId: String
    let floorId: String
}

final class SelectItemBuilder {
    
    private init() {}
    
    static func make(title: String, itemType: ItemType, presenter: SelectItemPresenter, callback: @escaping (SelectItemResult) -> Void) -> SelectItemViewController {
        let storyboard = UIStoryboard(name: "SelectItem", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectItemViewController") as! SelectItemViewController
        
        let token = SessionManager.shared.token
        let bookreenService = BookreenService(token: token)
        
        viewController.viewModel = SelectItemViewModel(title: title, itemType: itemType, presenter: presenter, bookreenService: bookreenService)
        viewController.callback = callback
        return viewController
    }
    
    static func makeBottomSheets(title: String, itemType: ItemType, presenter: SelectItemPresenter, callback: @escaping (SelectItemResult) -> Void) -> SheetViewController {
        let viewController = SelectItemBuilder.make(title: title, itemType: itemType, presenter: presenter, callback: callback)
        
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
