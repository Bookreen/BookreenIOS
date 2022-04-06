import Foundation
import UIKit

protocol SwitchViewDelegate {
    func onChanged(_ switchView: SwitchView)
}

@IBDesignable
final class SwitchView: UIView {
    
    fileprivate lazy var uiSwitch: UISwitch = {
        let view = UISwitch()
        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = ColorPalette.shared.accentColor
        view.addTarget(self, action: #selector(onChangeSwitchStatus), for: .valueChanged)
        return view
    }()
    

    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor.label
        return label
    }()
    

    var delegate: SwitchViewDelegate?
    var metadata: [String: Any] = [:]
    var id:String=""
   
    @IBInspectable
    public var isOn: Bool = false {
        didSet {
            self.uiSwitch.isOn = isOn
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
        self.addSubview(self.uiSwitch)
        self.addSubview(self.label)
        
        NSLayoutConstraint.activate(
            [
                self.uiSwitch.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.uiSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor) ,
                self.label.leadingAnchor.constraint(equalTo: self.uiSwitch.trailingAnchor, constant: 6),
                
            ]
        )
    }
    
    @objc func onChangeSwitchStatus() {
        self.isOn=self.uiSwitch.isOn
        self.delegate?.onChanged(self)
    }
}
