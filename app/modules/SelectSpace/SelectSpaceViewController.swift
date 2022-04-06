import Foundation
import UIKit

final class SelectSpaceViewController: AppViewController {

    private var viewControllers: [UIViewController] = []
    
    private let activeColor = ColorPalette.shared.accentColor
    private let passiveColor = UIColor.secondaryLabel
    
    @IBOutlet weak var imageViewFloorPlan: UIImageView!
    @IBOutlet weak var labelFloorPlan: UILabel!
    
    @IBOutlet weak var imageViewList: UIImageView!
    @IBOutlet weak var labelList: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var imageViewSpace: UIImageView!
    @IBOutlet weak var labelSpace: UILabel!
    @IBOutlet weak var labelSpaceTitle: UILabel!
    @IBOutlet weak var viewFilterSpace: UIView!
    
    var callback: ((ReservationSpaceModel) -> Void)?
    var viewModel: SelectSpaceViewModelProtocol!
    private var activeViewController: UIViewController?

    
    var activeIndex = 0 {
        didSet {
            switch self.activeIndex {
            case 0:
                self.imageViewFloorPlan.tintColor = self.activeColor
                self.imageViewList.tintColor = self.passiveColor
                self.labelList.textColor = self.passiveColor
                self.labelFloorPlan.textColor = self.activeColor
            case 1:
                self.imageViewFloorPlan.tintColor = self.passiveColor
                self.imageViewList.tintColor = self.activeColor
                self.labelList.textColor = self.activeColor
                self.labelFloorPlan.textColor = self.passiveColor
            default:
                self.imageViewFloorPlan.tintColor = self.passiveColor
                self.imageViewList.tintColor = self.passiveColor
                self.labelList.textColor = self.passiveColor
                self.labelFloorPlan.textColor = self.passiveColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=viewModel.spaceType == .desk ? S.selectDesk.localized() : S.selectMeetingSpace.localized()
        self.viewFilterSpace.layer.cornerRadius = 10
        viewFilterSpace.isUserInteractionEnabled=true
        viewFilterSpace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedButtonFilter)))
        self.labelSpaceTitle.text = title
        
        self.labelSpace.text = ""
        
        
        self.imageViewFloorPlan.image = UIImage(named: "streeMap")!
        self.labelFloorPlan.text = S.floorPlan.localized()
        
        self.imageViewList.image = UIImage(named: "list")!
        self.labelList.text = S.list.localized()
        
        self.activeIndex = 0
    }
    
    private func initializeViewController() {
        if self.viewControllers.count == 0 {
            let floorPlanPresenter = FloorPlanViewPresenter(
                planDate: self.viewModel.planDate,
                startTime: self.viewModel.startTime,
                endTime: self.viewModel.endTime,
                selectedSpace: self.viewModel.selectedSpace)
            let floorPlanViewController = FloorPlanBuilder.make(spaceType:viewModel.spaceType,presenter: floorPlanPresenter) { selectedSpace in
                self.viewModel.selectedSpace = selectedSpace
                self.navigationController?.popViewController(animated: true)
                self.callback?(selectedSpace)
            }
            self.viewControllers.append(floorPlanViewController)
            
            let spaceListPresenter = SpaceListViewPresenter(
                planDate: self.viewModel.planDate,
                startTime: self.viewModel.startTime,
                endTime: self.viewModel.endTime,
                selectedSpace: self.viewModel.selectedSpace)
            
            let spaceListViewController = SpaceListBuilder.make(spaceType: viewModel.spaceType, presenter: spaceListPresenter) { selectedSpace in
                self.viewModel.selectedSpace = selectedSpace
                self.navigationController?.popViewController(animated: true)
                self.callback?(selectedSpace)
            }
            self.viewControllers.append(spaceListViewController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeViewController()
        self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
        self.configureTitle()
    }
    
    private func configureTitle() {
        if let _space = self.viewModel.selectedSpace {
            self.labelSpace.text = _space.locationDescription()
        } else {
            self.labelSpace.text = ""
        }
    }
    
    
    private func setViewControllerToContainerView(_ viewController: UIViewController) {
        if let activeViewController = self.activeViewController {
            self.removeViewControllerFromContainerView(activeViewController)
        }
        self.activeViewController = viewController
        addChild(viewController)
        self.viewContainer.addSubview(viewController.view)
        viewController.view.frame = self.viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        self.pushNotification()
    }
    
    private func removeViewControllerFromContainerView(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func pushNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let userInfo: [String: String] = [
                "campusId": self.viewModel.selectedSpace?.campusId ?? "",
                "campusTitle": self.viewModel.selectedSpace?.campusName ?? "",
                "buildingId": self.viewModel.selectedSpace?.buildingId ?? "",
                "buildingTitle": self.viewModel.selectedSpace?.buildingName ?? "",
                "floorId": self.viewModel.selectedSpace?.floorId ?? "",
                "floorTitle": self.viewModel.selectedSpace?.floorName ?? "",
                "spaceId": self.viewModel.selectedSpace?.spaceId ?? "",
                "spaceTitle": self.viewModel.selectedSpace?.spaceName ?? ""
            ]
            NotificationCenter.default.post(name: .didChangeSelectedOffice, object: nil, userInfo: userInfo)
        }
    }
    
    @IBAction func pressedButtonFloorPlan(_ sender:  UIButton) {
        if self.activeIndex != 0 {
            self.activeIndex = 0
            self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
        }
    }
    
    @IBAction func pressedButtonList(_ sender: UIButton) {
        if self.activeIndex != 1 {
            self.activeIndex = 1
            self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
        }
    }
    
    @objc private func pressedButtonFilter() {
        var campusId = ""
        var campusTitle = ""
        var buildingId = ""
        var buildingTitle = ""
        var floorId = ""
        var floorTitle = ""
        
        if let _space = self.viewModel.selectedSpace {
            campusId = _space.campusId ?? ""
            campusTitle = _space.campusName ?? ""
            buildingId = _space.buildingId ?? ""
            buildingTitle = _space.buildingName ?? ""
            floorId = _space.floorId ?? ""
            floorTitle = _space.floorName ?? ""
        }
        
        let presenter = FilterSpacePresenter(campusId: campusId, campusTitle: campusTitle, buildingId: buildingId, buildingTitle: buildingTitle, floorId: floorId, floorTitle: floorTitle)
        let viewController = FilterSpaceBuilder.makeBottomSheets(presenter: presenter) { result in
            switch result {
            case .changedOffice(let office):
                self.viewModel.selectedSpace = ReservationSpaceModel(
                    spaceId: "",
                    spaceName: "",
                    campusId: office.campusId,
                    campusName: office.campusTitle,
                    buildingId: office.buildingId,
                    buildingName: office.buildingTitle,
                    floorId: office.floorId,
                    floorName: office.floorTitle
                )
                self.configureTitle()
                self.pushNotification()
            case .openSearchFriend:
                let viewController = SearchFriendBuilder.make { result in
                    self.viewModel.selectedSpace = ReservationSpaceModel(
                        spaceId: result.spaceId,
                        spaceName: result.locationName,
                        campusId: result.campusId,
                        campusName: result.campusName,
                        buildingId: result.buildingId,
                        buildingName: result.buildingName,
                        floorId: result.floorId,
                        floorName: result.floorName
                    )
                    self.configureTitle()
                    self.pushNotification()
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
}


extension SelectSpaceViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}
