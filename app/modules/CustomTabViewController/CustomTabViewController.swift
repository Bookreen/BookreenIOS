import Foundation
import UIKit

struct CustomTab {
    let tag: Int
    let tabItem: CustomTabItem
    let viewController: UIViewController
}

final class CustomTabViewController: AppViewController {
    
    private let unSelectedColor = ColorPalette.shared.colorGrey400
    private let selectedColor = ColorPalette.shared.colorWhite
    private var viewControllers: [CustomTab] = []
    private var activeTab: CustomTab?
    private var activeViewController: UIViewController?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabCircle: UIView!
    @IBOutlet weak var tabItemHome: CustomTabItem!
    @IBOutlet weak var tabItemCalendar: CustomTabItem!
    @IBOutlet weak var tabItemPreviewFloor: CustomTabItem!
    @IBOutlet weak var tabItemProfile: CustomTabItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTabCircle()
    }
    
    private func makeTabCircle() {
        self.tabCircle.layer.cornerRadius = self.tabCircle.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTabHandler(_:)), name: .didChangeTab, object: nil)
        self.customizeTabItems()
        self.viewControllers.forEach { item in
            item.tabItem.delegate = self
        }
        
        if self.activeTab == nil {
            self.activeTab = viewControllers[0]
            self.setViewControllerToContainerView(self.activeTab!.viewController)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.viewControllers.forEach { item in
            item.tabItem.delegate = nil
        }
    }
    
    private func customizeTabItems() {
        if self.viewControllers.count == 0 {
            let homeViewController = HomeBuilder.make()
            self.tabItemHome.tag = 1
            self.tabItemHome.isSelected = true
            self.tabItemHome.icon = UIImage(named: "home")
            self.tabItemHome.selectedColor = selectedColor
            self.tabItemHome.unSelectedColor = unSelectedColor
            self.viewControllers.append(CustomTab(tag: 1, tabItem: self.tabItemHome, viewController: homeViewController))
            
            let calendarViewController = CalendarBuilder.make()
            self.tabItemCalendar.tag = 2
            self.tabItemCalendar.icon = UIImage(named: "calendar")
            self.tabItemCalendar.selectedColor = selectedColor
            self.tabItemCalendar.unSelectedColor = unSelectedColor
            self.viewControllers.append(CustomTab(tag: 2, tabItem: self.tabItemCalendar, viewController: calendarViewController))

            let previewFloorViewController = PreviewFloorBuilder.make()
            self.tabItemPreviewFloor.tag = 3
            self.tabItemPreviewFloor.icon = UIImage(named: "location")
            self.tabItemPreviewFloor.selectedColor = selectedColor
            self.tabItemPreviewFloor.unSelectedColor = unSelectedColor
            self.viewControllers.append(CustomTab(tag: 3, tabItem: self.tabItemPreviewFloor, viewController: previewFloorViewController))

            let profileViewController = ProfileBuilder.make()
            self.tabItemProfile.tag = 4
            self.tabItemProfile.icon = UIImage(named: "user")
            self.tabItemProfile.selectedColor = selectedColor
            self.tabItemProfile.unSelectedColor = unSelectedColor
            self.viewControllers.append(CustomTab(tag: 4, tabItem: self.tabItemProfile, viewController: profileViewController))
        }
    }
    
    private func setViewControllerToContainerView(_ viewController: UIViewController) {
        if let activeViewController = self.activeViewController {
            self.removeViewControllerFromContainerView(activeViewController)
        }
        self.activeViewController = viewController
        addChild(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func removeViewControllerFromContainerView(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    @IBAction func pressedButtonAdd(_ sender: UIButton) {
        let sheet=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: S.office.localized(), style: .default, handler: { _ in
            let viewController = NewOfficeReservationBuilder.make()
            self.navigationController?.pushViewController(viewController, animated: true)
            self.updateStatusBar()
        }))
        sheet.addAction(UIAlertAction(title: S.meeting.localized(), style: .default, handler: { _ in
            let viewController = MeetingViewBuilder.build()
            self.navigationController?.pushViewController(viewController, animated: true)
            self.updateStatusBar()
        }))
        sheet.view.tintColor = ColorPalette.shared.accentColor
        sheet.addAction(UIAlertAction(title: S.cancel.localized(), style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func getStatusBarStyle()->UIStatusBarStyle{
        if let tag=activeTab?.tag{
            return tag < 3 ? .lightContent : .default
        }
        return .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if let tag=activeTab?.tag{
            return tag < 3 ? .lightContent : .default
        }
        return .lightContent
    }
    
    @objc func didChangeTabHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let index = data["index"] ?? 0
            
            var tab: CustomTab?

            self.viewControllers.forEach { item in
                if item.tag == index {
                   tab = item
                }
                item.tabItem.isSelected = false
            }
            if let _tab = tab {
                _tab.tabItem.isSelected = true
                self.activeTab = _tab
                self.setViewControllerToContainerView(_tab.viewController)
            }
            updateStatusBar()
        }
    }
}

extension CustomTabViewController: CustomTabItemDelegate {
    func onSelectedTab(_ tag: Int) {
        self.viewControllers.forEach { item in
            item.tabItem.isSelected = item.tag == tag
            if item.tag == tag {
                self.activeTab = item
                self.setViewControllerToContainerView(item.viewController)
                updateStatusBar()
            }
        }
    }
    
    private func updateStatusBar(){
        guard let root=navigationController  as? ApplicationNavigationController else {
            return
        }
        if let tag=activeTab?.tag{
            root.updateStatusBar(tag < 3 ? .lightContent : .default)
        }else{
            root.updateStatusBar(.lightContent)
        }
    }
}
