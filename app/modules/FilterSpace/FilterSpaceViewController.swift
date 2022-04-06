import Foundation
import UIKit

final class FilterSpaceViewController: AppViewController {
    
    
    @IBOutlet weak var filterView: UISegmentedControl!
    @IBOutlet weak var buttonDepartment: UIButton!
    @IBOutlet weak var buttonChangeOffice: UIButton!
    @IBOutlet weak var buttonMyOffice: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var labelOr: UILabel!
    @IBOutlet weak var viewSelectFriend: UIView!
    @IBOutlet weak var labelSelectFriend: UILabel!
    
    private var activeViewController: UIViewController?
    private var viewControllers: [UIViewController] = []

    var callback: ((FilterSpaceResult) -> Void)?
    var viewModel: FilterSpaceViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonSubmit.setTitle(S.ok.localized().uppercased(), for: .normal)
        self.buttonSubmit.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
        
        self.buttonSubmit.backgroundColor = ColorPalette.shared.accentColor
        self.buttonSubmit.layer.cornerRadius = 8
        
        self.labelSelectFriend.text = S.searchFriend.localized()
        viewSelectFriend.layer.cornerRadius=10.0
        viewSelectFriend.isUserInteractionEnabled=true
        viewSelectFriend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedButtonSelectFriend)))
        filterView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        [S.department,S.myOffice,S.selectOffice]
            .enumerated().forEach {
                filterView.setTitle($0.element.localized(), forSegmentAt: $0.offset)
            }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeFilterOfficeHandler(_:)), name: .didChangeFilterOffice, object: nil)
        self.initializeViewController()
        self.viewModel.delegate = self
        self.viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
    }
    
    @IBAction func pressedButtonDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFilterTap(_ sender: Any) {
        viewModel.activeTabTag=filterView.selectedSegmentIndex
    }
    
    @IBAction func pressedButtonSubmit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.changedOffice(self.viewModel.filterOffice))
    }
    
    @objc private func pressedButtonSelectFriend() {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.openSearchFriend)
    }
    
    @objc func didChangeFilterOfficeHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let campusId = data["campusId"] ?? ""
            let campusTitle = data["campusTitle"] ?? ""
            let buildingId = data["buildingId"] ?? ""
            let buildingTitle = data["buildingTitle"] ?? ""
            let floorId = data["floorId"] ?? ""
            let floorTitle = data["floorTitle"] ?? ""
            
            self.viewModel.filterOffice = FilterOfficeOutput(
                campusId: campusId,
                campusTitle: campusTitle,
                buildingId: buildingId,
                buildingTitle: buildingTitle,
                floorId: floorId,
                floorTitle: floorTitle)
        }
    }
    
    private func initializeViewController() {
        if self.viewControllers.count == 0 {
            let campusId = self.viewModel.presenter.campusId
            let campusTitle = self.viewModel.presenter.campusTitle
            let buildingId = self.viewModel.presenter.buildingId
            let buildingTitle = self.viewModel.presenter.buildingTitle
            let floorId = self.viewModel.presenter.floorId
            let floorTitle = self.viewModel.presenter.floorTitle
            
            let filterDepartmentViewController = FilterDepartmentBuilder.make()
            self.viewControllers.append(filterDepartmentViewController)
            
            let filterMyOfficePresenter = FilterMyOfficePresenter(campusId: campusId, campusTitle: campusTitle, buildingId: buildingId, buildingTitle: buildingTitle, floorId: floorId, floorTitle: floorTitle)
            
            let filterMyOfficeViewController = FilterMyOfficeBuilder.make(presenter: filterMyOfficePresenter)
            self.viewControllers.append(filterMyOfficeViewController)
            
            let filterSelectOfficePresenter = FilterSelectOfficePresenter(campusId: campusId, campusTitle: campusTitle, buildingId: buildingId, buildingTitle: buildingTitle, floorId: floorId, floorTitle: floorTitle)
            let filterSelectOfficeViewController = FilterSelectOfficeBuilder.make(presenter: filterSelectOfficePresenter)
            self.viewControllers.append(filterSelectOfficeViewController)
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
    }
    
    private func removeViewControllerFromContainerView(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension FilterSpaceViewController : FilterSpaceViewModelDelegate {
    func handleOutput(_ output: FilterSpaceViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .ChangedActiveTag:
                self.setViewControllerToContainerView(self.viewControllers[self.viewModel.activeTabTag])
            }
        }
    }
}
