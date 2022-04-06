import Foundation
import UIKit

protocol ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView)
}

@IBDesignable
final class ImageButtonView: UIView {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    var delegate: ImageButtonViewDelegate?
    
    @IBInspectable
    public var iconTintColor: UIColor = .white {
        didSet {
            self.imageView.tintColor = self.iconTintColor
        }
    }
    
    @IBInspectable
    public var icon: UIImage? = nil {
        didSet {
            self.imageView.image = self.icon
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
        self.addSubview(self.imageView)
        self.addSubview(self.button)
        
        NSLayoutConstraint.activate(
            [
                self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
                self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
                self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.button.topAnchor.constraint(equalTo: self.topAnchor),
                self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
    
    @objc func pressedButton() {
        self.delegate?.imageButtonView(pressed: self)
    }
}

