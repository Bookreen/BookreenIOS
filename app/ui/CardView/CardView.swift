import Foundation
import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 2 {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable var shadowOffsetWidth: Int = 0 {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable var shadowOffsetHeight: Int = 0 {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? = .black {
        didSet {
            self.configureView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.configureView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.configureView()
    }
    
    private func configureView() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor?.cgColor
        self.layer.shadowOffset = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

}
