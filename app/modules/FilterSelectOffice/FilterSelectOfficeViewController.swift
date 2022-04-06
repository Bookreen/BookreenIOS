import Foundation
import UIKit

final class FilterSelectOfficeViewController: AppViewController {
    
    @IBOutlet weak var viewCampus: UIView!
    @IBOutlet weak var labelCampusTitle: UILabel!
    @IBOutlet weak var labelCampus: UILabel!
    
    @IBOutlet weak var viewBuilding: UIView!
    @IBOutlet weak var labelBuildingTitle: UILabel!
    @IBOutlet weak var labelBuilding: UILabel!
    
    @IBOutlet weak var viewFloor: UIView!
    @IBOutlet weak var labelFloorTitle: UILabel!
    @IBOutlet weak var labelFloor: UILabel!
    
    var viewModel: FilterSelectOfficeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [viewCampus,viewFloor,viewBuilding]
            .forEach {
                $0?.layer.cornerRadius=10.0
            }
        
        self.labelCampusTitle.text = "campus".localized()
        self.labelBuildingTitle.text = "building".localized()
        self.labelFloorTitle.text = "floor".localized()

        self.labelCampus.text = "pleaseSelectCampus".localized()
        self.labelBuilding.text = "pleaseSelectBuilding".localized()
        self.labelFloor.text = "pleaseSelectFloor".localized()
        
        self.updateUI()
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
    
    private func updateUI() {
        self.labelCampus.text = self.viewModel.presenter.campusTitle
        self.labelBuilding.text = self.viewModel.presenter.buildingTitle
        self.labelFloor.text = self.viewModel.presenter.floorTitle
    }
    
    @IBAction func pressedButtonCampus(_ button: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectCampus".localized(), itemType: .campus, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonBuilding(_ button: UIButton) {
        let campusId = self.viewModel.selectedCampus?.id ?? ""
        let buildingId = self.viewModel.selectedBuilding?.id ?? ""
        let floorId = self.viewModel.selectedFloor?.id ?? ""
        self.showSelectItemViewController(title: "pleaseSelectBuilding".localized(), itemType: .building, campusId: campusId, buildingId: buildingId, floorId: floorId)
    }
    
    @IBAction func pressedButtonFloor(_ button: UIButton) {
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
            self.pushNotification()
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func pushNotification() {
        let userInfo: [String: String] = [
            "campusId": self.viewModel.selectedCampus?.id ?? "",
            "campusTitle": self.viewModel.selectedCampus?.name ?? "",
            "buildingId": self.viewModel.selectedBuilding?.id ?? "",
            "buildingTitle": self.viewModel.selectedBuilding?.name ?? "",
            "floorId": self.viewModel.selectedFloor?.id ?? "",
            "floorTitle": self.viewModel.selectedFloor?.name ?? ""
        ]
        NotificationCenter.default.post(name: .didChangeFilterOffice, object: nil, userInfo: userInfo)
    }
}

extension FilterSelectOfficeViewController: FilterSelectOfficeViewModelDelegate {
    func handleOutput(_ output: FilterSelectOfficeViewOutput) {
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
                    if item.id == self.viewModel.presenter.buildingId {
                        self.viewModel.selectedBuilding = item
                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            case .successGetCampusList:
                self.viewModel.campusList.forEach { item in
                    if item.id == self.viewModel.presenter.campusId {
                        self.viewModel.selectedCampus = item
                    }
                }
                self.configureViewCampus()
                self.configureViewBuilding()
                self.configureViewFloor()
            case .successGetFloorList:
                self.viewModel.floorList.forEach { item in
                    if item.id == self.viewModel.presenter.floorId {
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
