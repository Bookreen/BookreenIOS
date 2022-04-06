import Foundation
import UIKit

public extension UIViewController {
    
    
    func getSafeAreaInsetsBottom() -> CGFloat {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            return keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
    }
    
    func getSafeAreaInsetsTop() -> CGFloat {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            return keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
    }
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func constraintX(originAnchor: NSLayoutXAxisAnchor, destinationAnchor: NSLayoutXAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate(
            [
                originAnchor.constraint(equalTo: destinationAnchor, constant: constant)
            ]
        )
    }
    
    func constraintY(originAnchor: NSLayoutYAxisAnchor, destinationAnchor: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate(
            [
                originAnchor.constraint(equalTo: destinationAnchor, constant: constant)
            ]
        )
    }
    
    func constraintY(originAnchor: NSLayoutYAxisAnchor, destinationAnchor: NSLayoutYAxisAnchor, greaterThanOrEqualToConstant: CGFloat) {
        NSLayoutConstraint.activate(
            [
                originAnchor.constraint(greaterThanOrEqualTo: destinationAnchor, constant: greaterThanOrEqualToConstant)
            ]
        )
    }
}
