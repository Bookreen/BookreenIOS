import Foundation
import UIKit

final class ContactUsViewController: AppViewController {
    
    private let buttonDisableBackgroundColor = ColorPalette.shared.accentColor.withAlphaComponent(0.5)
    private let buttonBackgroundColor = ColorPalette.shared.accentColor
    private let buttonTitleColor = ColorPalette.shared.colorWhite
    private let buttonCornerRadius: CGFloat = 8
    private let buttonFont: UIFont = .systemFont(ofSize: 16)
    private let textColor = ColorPalette.shared.colorBlack
    
    private let textFieldBorderColor: UIColor = ColorPalette.shared.accentColor
    private let textFieldBorderWidth: CGFloat = 1
    private let textFieldCornerRadius: CGFloat = 4
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelInformation: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var textFieldSubject: InsetTextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var buttonSend: UIButton!
    
    var viewModel: ContactUsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=S.contactUs.localized()
        self.labelTitle.text = "contactUs".localized()
        
        self.labelInformation.text = "contactUsInformation".localized()
        
        self.labelSubject.text = "subject".localized()
        
        self.textFieldSubject.tag = 1
        self.textFieldSubject.layer.borderWidth = self.textFieldBorderWidth
        self.textFieldSubject.layer.cornerRadius = self.textFieldCornerRadius
        self.textFieldSubject.layer.borderColor = self.textFieldBorderColor.cgColor
        self.textFieldSubject.placeholder = ""
        self.textFieldSubject.horizontalInset = 8
        self.textFieldSubject.verticalInset = 0
        self.textFieldSubject.addTarget(self, action: #selector(changedInputs), for: .editingChanged)
        
        self.labelMessage.text = "message".localized()
        
        self.textViewMessage.tag = 2
        self.textViewMessage.layer.borderWidth = self.textFieldBorderWidth
        self.textViewMessage.layer.cornerRadius = self.textFieldCornerRadius
        self.textViewMessage.layer.borderColor = self.textFieldBorderColor.cgColor
        self.textViewMessage.text = ""
        self.textViewMessage.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)

        self.buttonSend.backgroundColor = self.buttonBackgroundColor
        self.buttonSend.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonSend.titleLabel?.font = buttonFont
        self.buttonSend.setTitle("send".localized(), for: .normal)
        self.buttonSend.layer.cornerRadius = buttonCornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.textFieldSubject.delegate = self
        self.textViewMessage.delegate = self
        self.changedInputs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        NotificationCenter.default.removeObserver(self)
        self.textFieldSubject.delegate = nil
        self.textViewMessage.delegate = nil
    }
    
    @objc func changedInputs() {
        let subject = self.textFieldSubject.text ?? ""
        let message = self.textViewMessage.text ?? ""
        self.viewModel.validInputs(subject: subject, message: message)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 24
        self.scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    @IBAction func pressedButtonSend(_ sender: UIButton) {
        let subject = self.textFieldSubject.text ?? ""
        let message = self.textViewMessage.text ?? ""
        self.viewModel.giveFeedback(subject: subject, message: message)
    }
}

extension ContactUsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            return self.textViewMessage.becomeFirstResponder()
        }
        return textField.resignFirstResponder()
    }
}


extension ContactUsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.changedInputs()
    }
}


extension ContactUsViewController: ContactUsViewModelDelegate {
    func handleOutput(_ output: ContactUsViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .failureGiveFeedback:
                self.navigationController?.popViewController(animated: true)
            case .successGiveFeedback:
                self.navigationController?.popViewController(animated: true)
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            case .isValidInput(let isValid):
                self.buttonSend.isUserInteractionEnabled = isValid
                self.buttonSend.alpha = isValid ? 1.0 : 0.5
            }
        }
    }
}
