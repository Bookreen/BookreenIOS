import Foundation
import UIKit

@IBDesignable
public final class RadiusView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    public override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    private func setupView() {
        self.setupCornerRadius()
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
                roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
