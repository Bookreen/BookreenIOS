import Foundation
import UIKit

final class ApplicationNavigationController: UINavigationController {
    
    private var statusBarStyle = UIStatusBarStyle.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingView), name: .showLoadingView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissLoadingView), name: .dismissLoadingView, object: nil)
    }
    
    func updateStatusBar(_ style:UIStatusBarStyle){
        if (topViewController as? CustomTabViewController) != nil{
            self.statusBarStyle=style
        }else{
            self.statusBarStyle = .default
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if let top=topViewController as? CustomTabViewController{
            updateStatusBar(top.getStatusBarStyle())
        }else{
            updateStatusBar(.default)
        }
    }
    
   
    override func popViewController(animated: Bool) -> UIViewController? {
        let r=super.popViewController(animated: animated)
        if let top=topViewController as? CustomTabViewController{
            updateStatusBar(top.getStatusBarStyle())
        }
        return r
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return statusBarStyle
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showLoadingView() {
        self.displayAnimatedActivityIndicatorView()
    }
    
    @objc func dismissLoadingView() {
        self.hideAnimatedActivityIndicatorView()
    }
}
