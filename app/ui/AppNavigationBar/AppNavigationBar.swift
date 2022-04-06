import Foundation
import UIKit

@IBDesignable
final class AppNavigationBar: UIView {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var leftButtonView: ImageButtonView = {
        let button = ImageButtonView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBInspectable
    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.labelTitle.font = self.font
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .white {
        didSet {
            self.labelTitle.textColor = textColor
        }
    }
    
    @IBInspectable
    public var text: String = "" {
        didSet {
            self.labelTitle.text = self.text
        }
    }
    
    @IBInspectable
    public var icon: UIImage? = nil {
        didSet {
            self.imageView.image = self.icon
        }
    }
    
    @IBInspectable
    public var leftIconTintColor: UIColor = .white {
        didSet {
            self.leftButtonView.iconTintColor = self.leftIconTintColor
        }
    }

    @IBInspectable
    public var leftIcon: UIImage? = nil {
        didSet {
            self.leftButtonView.icon = self.leftIcon
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.leftButtonView)
        self.addSubview(self.imageView)
        self.addSubview(self.labelTitle)
        
        NSLayoutConstraint.activate(
            [
                self.leftButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                self.leftButtonView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.leftButtonView.heightAnchor.constraint(equalToConstant: 36),
                self.leftButtonView.widthAnchor.constraint(equalTo: self.leftButtonView.heightAnchor),
                self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
                self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.imageView.widthAnchor.constraint(greaterThanOrEqualTo: self.imageView.heightAnchor),
                self.imageView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.5),
                self.labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
}
