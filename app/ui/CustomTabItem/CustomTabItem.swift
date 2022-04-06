import Foundation
import UIKit

protocol CustomTabItemDelegate {
    func onSelectedTab(_ tag: Int)
}

@IBDesignable
final class CustomTabItem: UIView {
    
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
    
    var delegate: CustomTabItemDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    @IBInspectable
    public var icon: UIImage? = nil {
        didSet {
            if let _icon = self.icon {
                self.iconView.image = _icon
            }
        }
    }
    
    @IBInspectable
    public var isSelected: Bool = false {
        didSet {
            self.iconView.tintColor = self.isSelected ? self.selectedColor : self.unSelectedColor
        }
    }
    
    @IBInspectable
    public var selectedColor: UIColor = .white {
        didSet {
            self.iconView.tintColor = self.isSelected ? self.selectedColor : self.unSelectedColor
        }
    }
    
    @IBInspectable
    public var unSelectedColor: UIColor = .white {
        didSet {
            self.iconView.tintColor = self.isSelected ? self.selectedColor : self.unSelectedColor
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        self.setupView()
    }
    
    private func setupView() {
        self.addSubview(self.iconView)
        self.addSubview(self.button)
        
        NSLayoutConstraint.activate(
            [
                self.iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.button.topAnchor.constraint(equalTo: self.topAnchor),
                self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
    
    @objc func pressedButton() {
        self.delegate?.onSelectedTab(self.tag)
    }
}
