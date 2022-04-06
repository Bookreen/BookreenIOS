import Foundation
import UIKit
import FittedSheets

final class LoginViewController: AppViewController {
    
    @IBOutlet weak var textFieldUsername: IconTextField!
    @IBOutlet weak var textFieldPassword: IconTextField!
    @IBOutlet weak var buttonForgetPassword: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var imageViewVisibility: UIImageView!
    
    private let visibilityOff: UIImage = UIImage(named: "visibility_off")!
    private let visibility: UIImage = UIImage(named: "visibility")!
    private var isVisibility: Bool = false
    
    var viewModel: LoginViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.shared.colorBlueGrey700
        
        self.textFieldUsername.backgroundColor = .clear
        self.textFieldUsername.layer.borderWidth = 1
        self.textFieldUsername.layer.borderColor = ColorPalette.shared.colorWhite.cgColor
        self.textFieldUsername.font = .systemFont(ofSize: 14)
        self.textFieldUsername.tag = 1
        self.textFieldUsername.cornerRadius = 4
        self.textFieldUsername.placeHolder = "username".localized()
        self.textFieldUsername.placeHolderFont = .systemFont(ofSize: 14)
        self.textFieldUsername.textColor = ColorPalette.shared.colorWhite
        self.textFieldUsername.iconColor = ColorPalette.shared.colorWhite
        self.textFieldUsername.placeHolderColor = ColorPalette.shared.colorWhite.withAlphaComponent(0.7)
        self.textFieldUsername.keyboardType = .default
        self.textFieldUsername.textFieldType = .username
        self.textFieldUsername.keyboardReturnKey = .next
        
        self.imageViewVisibility.tintColor = ColorPalette.shared.colorWhite
        self.textFieldPassword.backgroundColor = .clear
        self.textFieldPassword.layer.borderWidth = 1
        self.textFieldPassword.layer.borderColor = ColorPalette.shared.colorWhite.cgColor
        self.textFieldPassword.font = .systemFont(ofSize: 14)
        self.textFieldPassword.tag = 2
        self.textFieldPassword.cornerRadius = 4
        self.textFieldPassword.placeHolder = "password".localized()
        self.textFieldPassword.placeHolderFont = .systemFont(ofSize: 14)
        self.textFieldPassword.iconColor = ColorPalette.shared.colorWhite
        self.textFieldPassword.textColor = ColorPalette.shared.colorWhite
        self.textFieldPassword.placeHolderColor = ColorPalette.shared.colorWhite.withAlphaComponent(0.7)
        self.textFieldPassword.keyboardType = .default
        self.textFieldPassword.textFieldType = .password
        self.textFieldPassword.keyboardReturnKey = .done
        
        self.buttonLogin.layer.cornerRadius = 8
        self.buttonLogin.backgroundColor = ColorPalette.shared.accentColor
        self.buttonLogin.setTitleColor(.white, for: .normal)
        self.buttonLogin.setTitle("login".localized(), for: .normal)
        
        self.buttonForgetPassword.backgroundColor = .clear
        self.buttonForgetPassword.setTitleColor(.white, for: .normal)
        self.buttonForgetPassword.setTitle("forgetPassword".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
        self.viewModel.delegate = self
        let username = self.textFieldUsername.text 
        let password = self.textFieldPassword.text 
        self.viewModel.validInputs(username: username, password: password)
        self.updateVisibility()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textFieldUsername.delegate = nil
        self.textFieldPassword.delegate = nil
        self.viewModel.delegate = nil
    }
    
    private func updateVisibility() {
        if isVisibility {
            self.imageViewVisibility.image = visibilityOff
            self.textFieldPassword.isSecureTextEntry = false
        } else {
            self.imageViewVisibility.image = visibility
            self.textFieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func pressedButtonVisibility(_ sender: UIButton) {
        self.isVisibility = !isVisibility
        self.updateVisibility()
    }
    
    @IBAction func pressedButtonLogin(_ sender: UIButton) {
//        let sheetController = CustomAlertBuilder.makeBottomSheets(.success, message: "errorLogin".localized(), buttonTitle: "ok".localized())
//        self.present(sheetController, animated: true, completion: nil)
        let username = self.textFieldUsername.text
        let password = self.textFieldPassword.text
        self.viewModel.login(username: username, password: password)
    }
    
    @IBAction func pressedButtonForgetPassword(_ sender: UIButton) {
        let viewController = ForgetPasswordBuilder.makeBottomSheets { result in
            DispatchQueue.main.async {
                switch result.status {
                case .cancel:
                    print("cancel")
                case .error:
                    let sheetController = CustomAlertBuilder.makeBottomSheets(.error, message: result.message, buttonTitle: "ok".localized(), completion: nil)
                    self.present(sheetController, animated: true, completion: nil)
                case .success:
                    let sheetController = CustomAlertBuilder.makeBottomSheets(.success, message: result.message, buttonTitle: "ok".localized(), completion: nil)
                    self.present(sheetController, animated: true, completion: nil)
                }
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func goToPrivacyPolicy(user:UserModel) {
        let viewController = PrivacyBuilder.make(user: user)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToWelcome() {
        let viewController = WelcomeBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToHome() {
        let viewController = CustomTabBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LoginViewController: IconTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            return self.textFieldPassword.becomeFirstResponder()
        }
        return textField.resignFirstResponder()
    }
    
    func didChangeTextField(_ textField: UITextField) {
        let username = self.textFieldUsername.text 
        let password = self.textFieldPassword.text 
        self.viewModel.validInputs(username: username, password: password)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func handleOutput(_ output: LoginViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .failureLogin:
                self.showErrorMessage("errorLogin".localized())
            case .successLoginAndNavigateWelcome:
                self.goToWelcome()
            case .successLoginAndNavigateHome:
                self.goToHome()
            case .successLoginAndNavigatePrivacyPolicy(let u):
                self.goToPrivacyPolicy(user: u)
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            case .isValidInput(let isValid):
                self.buttonLogin.isUserInteractionEnabled = isValid
                self.buttonLogin.alpha = isValid ? 1.0 : 0.5
            }
        }
    }
}
