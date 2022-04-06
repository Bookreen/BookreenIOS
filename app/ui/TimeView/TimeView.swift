import Foundation
import UIKit

protocol TimeViewDelegate {
    func timeView(_ onSelected: TimeView)
}

@IBDesignable
public final class TimeView: UIView {
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
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
    
    var delegate: TimeViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var isEnableTopLeftCornerRadius: Bool = false {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var isEnableBottomLeftCornerRadius: Bool = false {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var isEnableTopRightCornerRadius: Bool = false {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var isEnableBottomRightCornerRadius: Bool = false {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var selectedBorderColor: UIColor = .clear {
        didSet {
            self.setupCornerRadius()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .black {
        didSet {
            self.configureViews()
        }
    }
    
    @IBInspectable
    public var selectedTextColor: UIColor = .black {
        didSet {
            self.configureViews()
        }
    }
    
    @IBInspectable
    public var defaultBackgroundColor: UIColor = .clear {
        didSet {
            self.configureViews()
        }
    }
    
    @IBInspectable
    public var selectedBackgroundColor: UIColor = .clear {
        didSet {
            self.configureViews()
        }
    }
    
    @IBInspectable
    public var isSelected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.setupCornerRadius()
                self.configureViews()
            }
        }
    }
    
    @IBInspectable
    public var text: String = "" {
        didSet {
            self.label.text = self.text
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.addSubview(self.backgroundView)
        self.addSubview(self.label)
        self.addSubview(self.button)
        self.setupCornerRadius()
        
        NSLayoutConstraint.activate(
            [
                self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
                self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.button.topAnchor.constraint(equalTo: self.topAnchor),
                self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
    
    private func setupCornerRadius() {
        var corners = UIRectCorner()
        
        if isEnableTopLeftCornerRadius {
            corners.insert(.topLeft)
        }
        
        if isEnableTopRightCornerRadius {
            corners.insert(.topRight)
        }
        
        if isEnableBottomLeftCornerRadius {
            corners.insert(.bottomLeft)
        }
        
        if isEnableBottomRightCornerRadius {
            corners.insert(.bottomRight)
        }
        
        DispatchQueue.main.async {
            let path = UIBezierPath(
                roundedRect: CGRect(x: 0, y: 0, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius)
            )
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.backgroundView.layer.mask = mask
            
            let borderLayer = CAShapeLayer()
            borderLayer.path = path.cgPath
            borderLayer.strokeColor = self.isSelected ? self.selectedBorderColor.cgColor : self.borderColor.cgColor
            borderLayer.lineWidth = self.borderWidth
            borderLayer.fillColor = self.isSelected ? self.selectedBackgroundColor.cgColor : self.defaultBackgroundColor.cgColor
            borderLayer.frame = self.bounds
            self.backgroundView.layer.addSublayer(borderLayer)
        }
    }
    
    private func configureViews() {
        DispatchQueue.main.async {
            self.label.textColor = self.isSelected ? self.selectedTextColor : self.textColor
        }
    }
    
    @objc func pressedButton() {
        self.delegate?.timeView(self)
    }
}
