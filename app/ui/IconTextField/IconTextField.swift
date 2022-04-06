import Foundation
import UIKit

public enum TextFieldType {
    case none
    case email
    case username
    case password
    case nameSurname
}

protocol IconTextFieldDelegate: AnyObject {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func didChangeTextField(_ textField: UITextField)
}

@IBDesignable
final class IconTextField: UIView, UITextFieldDelegate {
    
    var delegate: IconTextFieldDelegate?
    
    fileprivate lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        imageView.tintColor = .clear
        return imageView
    }()
    
    fileprivate lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        return textField
    }()
    
    override var tag: Int {
        get {
            return self.textField.tag
        }
        set {
            self.textField.tag = newValue
        }
    }
    
    var text: String {
        get {
            return self.textField.text ?? ""
        }
        set(value) {
            self.textField.text = value
        }
    }
    
    
    @IBInspectable
    public var icon: UIImage? = nil  {
        didSet {
            if let _icon = icon {
                self.iconView.image = _icon
            }
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var placeHolder: String = "" {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    @IBInspectable
    public var placeHolderColor: UIColor = .black {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .black {
        didSet {
            self.textField.textColor = self.textColor
        }
    }
    
    @IBInspectable
    public var placeHolderFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    @IBInspectable
    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.textField.font = self.font
        }
    }
    
    @IBInspectable
    public var iconColor: UIColor = .clear {
        didSet {
            self.iconView.tintColor = iconColor
        }
    }
    
    public var keyboardReturnKey: UIReturnKeyType = .default {
        didSet {
            self.textField.returnKeyType = self.keyboardReturnKey
        }
    }
    
    public var isSecureTextEntry: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = self.isSecureTextEntry
        }
    }
    
    public var textFieldType: TextFieldType = .none {
        didSet {
            switch self.textFieldType {
            case .none:
                self.textField.autocorrectionType = .no
                self.textField.autocapitalizationType = .none
                self.textField.textContentType = .none
                self.textField.keyboardType = .default
                self.textField.isSecureTextEntry = false
            case .email:
                self.textField.autocorrectionType = .no
                self.textField.autocapitalizationType = .none
                self.textField.textContentType = .emailAddress
                self.textField.keyboardType = .emailAddress
                self.textField.isSecureTextEntry = false
            case .password:
                self.textField.autocorrectionType = .no
                self.textField.autocapitalizationType = .none
                self.textField.textContentType = .password
                self.textField.keyboardType = .default
                self.textField.isSecureTextEntry = true
            case .nameSurname:
                self.textField.autocorrectionType = .yes
                self.textField.autocapitalizationType = .words
                self.textField.textContentType = .name
                self.textField.keyboardType = .default
                self.textField.isSecureTextEntry = false
            case .username:
                self.textField.autocorrectionType = .no
                self.textField.autocapitalizationType = .none
                self.textField.textContentType = .username
                self.textField.keyboardType = .default
                self.textField.isSecureTextEntry = false
            }
        }
    }
    
    @IBInspectable
    public var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textField.keyboardType = self.keyboardType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupView()
    }
    
    private func updatePlaceholder() {
        let placeholderMutableString = NSMutableAttributedString(
            string: self.placeHolder,
            attributes: [
                NSAttributedString.Key.font: self.placeHolderFont,
                NSAttributedString.Key.foregroundColor: self.placeHolderColor
            ]
        )
        self.textField.attributedPlaceholder = placeholderMutableString
    }
    
    private func setupView() {
        self.addSubview(self.iconView)
        self.addSubview(self.textField)
        
        NSLayoutConstraint.activate(
            [
                self.iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
                self.iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.textField.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 8),
                self.textField.topAnchor.constraint(equalTo: self.topAnchor),
                self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor, constant: 12)
            ]
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldReturn(textField) ?? false
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    @objc func didChangeTextField() {
        self.delegate?.didChangeTextField(self.textField)
    }
}
