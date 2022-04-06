import Foundation
import UIKit

final class SplashViewController: AppViewController {
    
    var viewModel: SplashViewModelProtocol!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Locale.current.identifier)
        SessionManager.shared.isShowLocationPermission = false
        self.imageView.flash(numberOfFlashes: 300)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.viewModel.login()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
    }
    
    private func goToHome() {
        let viewController = CustomTabBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToLogin() {
        let viewController = LoginBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    private func goToWelcome() {
        let viewController = WelcomeBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SplashViewController: SplashViewModelDelegate {
    func handleOutput(_ output: SplashViewOutput) {
        switch output {
        case .failureLogin:
            self.goToLogin()
        case .successLoginAndNavigateHome:
            goToHome()
        case .successLoginAndNavigateWelcome:
            goToWelcome()
        case .handleError(_):
            self.goToLogin()
        }
    }
}
