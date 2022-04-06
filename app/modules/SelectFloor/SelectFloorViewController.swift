import Foundation
import UIKit

final class SelectFloorViewController: AppViewController {
    
    @IBOutlet weak var labelTitle: UILabel!

    @IBOutlet weak var labelCampusTitle: UILabel!
    @IBOutlet weak var labelCampus: UILabel!
    
    @IBOutlet weak var labelBuildingTitle: UILabel!
    @IBOutlet weak var labelBuilding: UILabel!
    
    @IBOutlet weak var labelFloorTitle: UILabel!
    @IBOutlet weak var labelFloor: UILabel!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var viewModel: SelectFloorViewModelProtocol!
    
    var callback: ((SelectFloorCallback) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.labelTitle.textAlignment = .center
        self.labelTitle.text = "selectYourOffice".localized()
        
        self.buttonSubmit.setTitle("ok".localized(), for: .normal)
        self.buttonSubmit.titleLabel?.font = .boldSystemFont(ofSize: 14)
        self.buttonSubmit.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
        self.buttonSubmit.layer.cornerRadius = 8
        self.buttonSubmit.backgroundColor = ColorPalette.shared.accentColor
        
        self.configureViewCampus()
        self.configureViewBuilding()
        self.configureViewFloor()
    }
    
    private func configureViewCampus() {
       
        self.labelCampusTitle.text = "campus".localized()
        if let campus = self.viewModel.selectedCampus {
            self.labelCampus.text = campus.name
        } else {
            self.labelCampus.text = "pleaseSelectCampus".localized()
        }
    }
    
    private func configureViewBuilding() {
       
        self.labelBuildingTitle.text = "building".localized()
        if let building = self.viewModel.selectedBuilding {
            self.labelBuilding.text = building.name
        } else {
            self.labelBuilding.text = "pleaseSelectBuilding".localized()
        }
    }
    
    private func configureViewFloor() {
       
        self.labelFloorTitle.text = "floor".localized()
        if let floor = self.viewModel.selectedFloor {
            self.labelFloor.text = floor.name
        } else {
            self.labelFloor.text = "pleaseSelectFloor".localized()
        }
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.viewModel.getCampusList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.dismiss)
    }
    
    @IBAction func pressedButtonSubmit(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let campusName = self.viewModel.selectedCampus?.name ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let buildingName = self.viewModel.selectedBuilding?.name ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        let floorName = self.viewModel.selectedFloor?.name ?? ""
        
        let result = SelectFloorResult(
            campusName: campusName,
            campusId: campusId,
            buildingName: buildingName,
            buildingId: buildingId,
            floorName: floorName,
            floorId: floorId)
        
        self.dismiss(animated: true, completion: nil)
        self.callback?(.selectedFloor(result))
    }
    
    @IBAction func pressedButtonSelectCampus(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectCampus".localized(), itemType: .campus, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonSelectBuilding(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectBuilding".localized(), itemType: .building, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonSelectFloor(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectFloor".localized(), itemType: .floor, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    private func showSelectItemViewController(title : String, itemType: ItemType, campusId: String, buildingId: String, floorId: String) {
        let presenter = SelectItemPresenter(
            campusId: campusId,
            buildingId: buildingId,
            floorId: floorId
        )
        
        let viewController = SelectItemBuilder.makeBottomSheets(title: title, itemType: itemType, presenter: presenter) { result in
            switch result.itemType {
            case .campus:
                self.viewModel.selectedCampus = result.campus
            case .building:
                self.viewModel.selectedBuilding = result.building
            case .floor:
                self.viewModel.selectedFloor = result.floor
            }
            self.configureViewCampus()
            self.configureViewBuilding()
            self.configureViewFloor()
        }
        self.present(viewController, animated: true, completion: nil)
    }
}

extension SelectFloorViewController: SelectFloorViewModelDelegate {
    func handleOutput(_ output: SelectFloorViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            case .successGetBuildingList:
                self.viewModel.buildingList.forEach { item in
                    if item.id == SessionManager.shared.buildingId {
                        self.viewModel.selectedBuilding = item
                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            case .successGetCampusList:
                self.viewModel.campusList.forEach { item in
                    if item.id == SessionManager.shared.campusId {
                        self.viewModel.selectedCampus = item
                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            case .successGetFloorList:
                self.viewModel.floorList.forEach { item in
                    if item.id == SessionManager.shared.floorId {
                        self.viewModel.selectedFloor = item
                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            }
        }
    }
}
