import Foundation
import UIKit
import FittedSheets

public enum ForgetPasswordStatus {
    case success
    case error
    case cancel
}

public struct ForgetPasswordResult {
    let status: ForgetPasswordStatus
    let message: String
}

final class ForgetPasswordBuilder {
    
    private init() {}
    
    static func make(callback: @escaping (ForgetPasswordResult) -> Void) -> ForgetPasswordViewController {
        let storyboard = UIStoryboard(name: "ForgetPassword", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        viewController.callback = callback
        
        let token = SessionManager.shared.token
        let authService = AuthService(token: token)
        
        viewController.viewModel = ForgetPasswordViewModel(authService: authService)
        return viewController
    }
    
    static func makeBottomSheets(callback: @escaping (ForgetPasswordResult) -> Void) -> SheetViewController {
        let viewController = ForgetPasswordBuilder.make(callback: callback)
        
        let options = SheetOptions(
            pullBarHeight: 0,
            presentingViewCornerRadius: 0,
            shouldExtendBackground: false,
            useFullScreenMode: false,
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: viewController, sizes: [.fullscreen], options: options)
        sheetController.view.backgroundColor = .clear
        sheetController.contentBackgroundColor = .clear
        return sheetController
    }
}

