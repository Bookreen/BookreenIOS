import Foundation
import UIKit

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFont(textForAttribute: String, withFont font: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }

}
