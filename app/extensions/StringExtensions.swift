import Foundation
import UIKit
import Alamofire

public extension String {
    func localized(with comment: String = "", bundle: Bundle = Bundle.main) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: comment)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func attributedText(boldString: String, font: UIFont, boldFont: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont]
        let range = (self as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func hexStringToUIColor () -> UIColor {
        let hex:String = self
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func take(length: Int) -> String {
        return String(self.prefix(length))
    }
    
    func takeLast(length: Int) -> String {
        return String(self.suffix(length))
    }
    
    func convertDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func isValidDate(format: String) -> Bool {
        return convertDate(format: format) != nil
    }
    
    func base64ToImage()->UIImage?{
        if let data=Data(base64Encoded: self){
            return UIImage(data: data)
        }
        return nil
    }
    
    func base64ToImage(placeholder with:UIImage)->UIImage{
        if let data=Data(base64Encoded: self){
            return UIImage(data: data) ?? with
        }
        return with
    }
    
    func barcoded(size:CGSize=CGSize(width: 300, height: 300))->UIImage?{
        let filterName = "CIQRCodeGenerator"
        guard let data = data(using: .ascii),
              let filter = CIFilter(name: filterName) else {
                  return nil
              }
        filter.setValue(data, forKey: "inputMessage")
        guard let image = filter.outputImage else {
            return nil
        }
        let imageSize = image.extent.size
        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,
                                          y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)
        return UIImage(ciImage: scaledImage)
    }

}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
