import Foundation
import UIKit

final class ForgetPasswordViewController: AppViewController {
    
    @IBOutlet weak var textFieldEmail: IconTextField!
    @IBOutlet weak var labelForgetPasswordTitle: UILabel!
    @IBOutlet weak var labelForgetPasswordDescription: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var viewModel: ForgetPasswordViewModelProtocol!
    var callback: ((ForgetPasswordResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldEmail.tag = 1
        self.textFieldEmail.font = .systemFont(ofSize: 14)
        self.textFieldEmail.placeHolder = "email".localized()
        self.textFieldEmail.placeHolderFont = .systemFont(ofSize: 14)
        self.textFieldEmail.icon = UIImage(named: "email")
        self.textFieldEmail.iconColor = ColorPalette.shared.accentColor
        self.textFieldEmail.placeHolderColor = ColorPalette.shared.colorGrey500
        self.textFieldEmail.keyboardType = .default
        self.textFieldEmail.textFieldType = .email
        self.textFieldEmail.keyboardReturnKey = .done
        self.textFieldEmail.layer.borderColor = ColorPalette.shared.accentColor.cgColor
        self.textFieldEmail.layer.borderWidth = 1
        self.textFieldEmail.layer.cornerRadius = 8
        
        self.labelForgetPasswordTitle.backgroundColor = ColorPalette.shared.accentColor
        self.labelForgetPasswordTitle.textAlignment = .center
        self.labelForgetPasswordTitle.font = .systemFont(ofSize: 14)
        self.labelForgetPasswordTitle.text = "forgetPasswordTitle".localized()
        
        self.labelForgetPasswordDescription.textAlignment = .center
        self.labelForgetPasswordDescription.font = .systemFont(ofSize: 14)
        self.labelForgetPasswordDescription.text = "forgetPasswordDescription".localized()
        self.labelForgetPasswordDescription.textColor = .secondaryLabel
        self.labelForgetPasswordDescription.numberOfLines = 0
        
        
        self.buttonSubmit.layer.cornerRadius = 8
        self.buttonSubmit.backgroundColor = ColorPalette.shared.accentColor
        self.buttonSubmit.setTitleColor(.white, for: .normal)
        self.buttonSubmit.setTitle("resetPassword".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldEmail.delegate = self
        self.viewModel.delegate = self
        let email = self.textFieldEmail.text
        self.viewModel.validEmail(email)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textFieldEmail.delegate = nil
        self.viewModel.delegate = nil
    }
    
    @IBAction func pressedButtonSendEmail(_ sender: UIButton) {
        let email = self.textFieldEmail.text
        self.viewModel.sendEmail(email)
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callback?(ForgetPasswordResult(status: .cancel, message: ""))
        }
    }
}

extension ForgetPasswordViewController: IconTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func didChangeTextField(_ textField: UITextField) {
        let email = self.textFieldEmail.text
        self.viewModel.validEmail(email)
    }
}


extension ForgetPasswordViewController: ForgetPasswordViewModelDelegate {
    func handleOutput(_ output: ForgetPasswordViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            case .successSentEmail:
                self.dismiss(animated: true) {
                    self.callback?(ForgetPasswordResult(status: .success, message: "successForgetPassword".localized()))
                }
            case .errorSentEmail:
                self.dismiss(animated: true) {
                    self.callback?(ForgetPasswordResult(status: .error, message: "errorForgetPassword".localized()))
                }
            case .isValidEmail(let isValidEmail):
                self.buttonSubmit.isUserInteractionEnabled = isValidEmail
                self.buttonSubmit.alpha = isValidEmail ? 1.0 : 0.5
            }
        }
    }
}
