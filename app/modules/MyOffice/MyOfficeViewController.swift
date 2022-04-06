import Foundation
import UIKit

final class MyOfficeViewController: AppViewController {
    
    @IBOutlet weak var labelMyOffice: UILabel!
    @IBOutlet weak var labelMyOfficeDescription: UILabel!
    @IBOutlet weak var labelCampusTitle: UILabel!
    @IBOutlet weak var labelCampus: UILabel!
    @IBOutlet weak var labelBuildingTitle: UILabel!
    @IBOutlet weak var labelBuilding: UILabel!
    @IBOutlet weak var labelFloorTitle: UILabel!
    @IBOutlet weak var labelFloor: UILabel!
    
    var viewModel: MyOfficeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=S.myOffice.localized()
        self.labelMyOffice.text = "myOffice".localized()
        
        self.labelMyOfficeDescription.text = "myOfficeDescription".localized()
        
        self.labelCampusTitle.text = "campus".localized()
        
        self.labelCampus.text = ""
        self.labelCampus.numberOfLines = 0
        
        self.labelFloorTitle.text = "floor".localized()
        
        self.labelFloor.text = ""
        self.labelFloor.numberOfLines = 0
        
        self.labelBuildingTitle.text = "building".localized()

        self.labelBuilding.text = ""
        self.labelBuilding.numberOfLines = 0
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
    
    @IBAction func pressedButtonCampus(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectCampus".localized(), itemType: .campus, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonBuilding(_ sender: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectBuilding".localized(), itemType: .building, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonFloor(_ sender: UIButton) {
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
            self.viewModel.saveMyOffice()
        }
        self.present(viewController, animated: true, completion: nil)
    }
}

extension MyOfficeViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyOfficeViewController: MyOfficeViewModelDelegate {
    func handleOutput(_ output: MyOfficeViewOutput) {
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
                        self.viewModel.getFloorList(buildingId: item.id)

                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            case .successGetCampusList:
                self.viewModel.campusList.forEach { item in
                    if item.id == SessionManager.shared.campusId {
                        self.viewModel.selectedCampus = item
                        self.viewModel.getBuildingList(campusId: item.id)
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
            case .failureSaveMyOffice:
                print("failureSaveMyOffice")
            case .successSaveMyOffice:
                print("successSaveMyOffice")
            }
        }
    }
}
