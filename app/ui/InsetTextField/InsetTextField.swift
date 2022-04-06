import Foundation
import UIKit

@IBDesignable
class InsetTextField: UITextField {

    @IBInspectable
    var horizontalInset: CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var verticalInset: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
    }

}
