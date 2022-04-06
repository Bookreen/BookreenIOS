import Foundation
import UIKit

protocol CheckboxDelegate {
    func checkbox(_ onChecked: Checkbox)
}

@IBDesignable
final class Checkbox: UIView {
    
    fileprivate lazy var imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = ColorPalette.shared.colorWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var checkBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.imageViewIcon)
        NSLayoutConstraint.activate(
            [
                self.imageViewIcon.widthAnchor.constraint(equalToConstant: 12),
                self.imageViewIcon.heightAnchor.constraint(equalToConstant: 12),
                self.imageViewIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                self.imageViewIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
        return view
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = ColorPalette.shared.colorBlack
        return label
    }()
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 1)
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    var delegate: CheckboxDelegate?
    
    @IBInspectable
    public var checkBoxBorderWidth: CGFloat = 0 {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var checkBoxBorderColor: UIColor = .clear {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var checkBoxActiveBorderColor: UIColor = .clear {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var checkBoxBackgroundColor: UIColor = .clear {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var checkBoxActiveBackgroundColor: UIColor = .clear {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var icon: UIImage? = nil {
        didSet {
            self.imageViewIcon.image = icon
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var isSelected: Bool = false {
        didSet {
            self.configureCheckbox()
        }
    }
    
    @IBInspectable
    public var text: String = "" {
        didSet {
            self.label.text = text
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
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(self.checkBox)
        self.addSubview(self.label)
        self.addSubview(self.button)
        
        NSLayoutConstraint.activate(
            [
                self.checkBox.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.checkBox.widthAnchor.constraint(equalTo: self.checkBox.heightAnchor),
                self.checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.checkBox.topAnchor.constraint(equalTo: self.topAnchor),
                self.checkBox.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor) ,
                self.label.leadingAnchor.constraint(equalTo: self.checkBox.trailingAnchor, constant: 6),
                self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.button.topAnchor.constraint(equalTo: self.topAnchor),
                self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
    
    private func configureCheckbox() {
        self.checkBox.layer.borderWidth = self.checkBoxBorderWidth
        self.checkBox.layer.borderColor = self.isSelected ? self.checkBoxActiveBorderColor.cgColor : self.checkBoxBorderColor.cgColor
        self.checkBox.layer.backgroundColor = self.isSelected ? self.checkBoxActiveBackgroundColor.cgColor : self.checkBoxBackgroundColor.cgColor
        self.checkBox.layer.cornerRadius = self.cornerRadius
        self.imageViewIcon.alpha = self.isSelected ? 1 : 0
    }
    
    @objc func pressedButton() {
        self.isSelected = !self.isSelected
        self.delegate?.checkbox(self)
    }
}
