import Foundation
import UIKit

class AppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    public func handleError(_ error: Error) {
        
        if case AppError.nullUrl = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else if case AppError.nullData = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else if case AppError.unauthorized = error {
            SessionManager.shared.logout()
            self.restartApp()
        } else if case AppError.forbidden = error {
            self.showErrorMessage("errorForbidden".localized())
        } else if case AppError.unknownStatusCode = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else if case AppError.httpRequestError = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else if case AppError.serializationError = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else if case AppError.httpResponseError(let message) = error {
            self.showErrorMessage(message)
        } else if case AppError.nullFile = error {
            self.showErrorMessage("errorUnknownStatusCode".localized())
        } else {
            print(error)
            self.showErrorMessage("systemError".localized())
        }
    }
    
    func showSuccessMessage(_ message: String, completion: (() -> Void)? = nil) {
        let viewController = CustomAlertBuilder.makeBottomSheets(.success, message: message, buttonTitle: "ok".localized(), completion: completion)
        self.present(viewController, animated: true, completion: completion)
    }
    
    func showErrorMessage(_ message: String, completion: (() -> Void)? = nil) {
        let viewController = CustomAlertBuilder.makeBottomSheets(.error, message: message, buttonTitle: "ok".localized(), completion: completion)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func restartApp() {
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first {
            app.router.start(keyWindow)
        } else {
            let viewController = LoginBuilder.make()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}
