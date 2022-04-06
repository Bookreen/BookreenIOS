import Foundation
import UIKit

final class MyContactsViewController: AppViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelFollowedUsers: UILabel!
    @IBOutlet weak var labelUsers: UILabel!
    @IBOutlet weak var viewLineFollowedUsers: UIView!
    @IBOutlet weak var viewLineUsers: UIView!
    
    private var activeViewController: UIViewController?
    private var viewControllers: [UIViewController] = []
    
    private let activeColor = ColorPalette.shared.accentColor
    private let passiveColor = UIColor.secondaryLabel
    private let passiveLineColor = UIColor.separator
    
    var activeIndex = 0 {
        didSet {
            switch self.activeIndex {
            case 0:
                self.labelFollowedUsers.textColor = self.activeColor
                self.viewLineFollowedUsers.backgroundColor = self.activeColor
                self.labelUsers.textColor = self.passiveColor
                self.viewLineUsers.backgroundColor = self.passiveLineColor
            case 1:
                self.labelUsers.textColor = self.activeColor
                self.viewLineUsers.backgroundColor = self.activeColor
                self.labelFollowedUsers.textColor = self.passiveColor
                self.viewLineFollowedUsers.backgroundColor = self.passiveColor
            default:
                self.labelUsers.textColor = self.passiveColor
                self.viewLineUsers.backgroundColor = self.passiveColor
                self.labelFollowedUsers.textColor = self.passiveColor
                self.viewLineFollowedUsers.backgroundColor = self.passiveLineColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "myContacts".localized()
       
        self.labelFollowedUsers.text = "followedUsers".localized()
        
        self.labelUsers.text = "users".localized()
        
        self.activeIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeViewController()
        self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initializeViewController() {
        if self.viewControllers.count == 0 {
            let followedUsersViewController = FollowedUsersBuilder.make()
            self.viewControllers.append(followedUsersViewController)
            
            let personsViewController = PersonsBuilder.make()
            self.viewControllers.append(personsViewController)
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
    
    @IBAction func pressedButtonFollowedUsers(_ sender: UIButton) {
        if self.activeIndex != 0 {
            self.activeIndex = 0
            self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
        }
    }
    
    @IBAction func pressedButtonUsers(_ sender: UIButton) {
        if self.activeIndex != 1 {
            self.activeIndex = 1
            self.setViewControllerToContainerView(self.viewControllers[self.activeIndex])
        }
    }
}

extension MyContactsViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}

