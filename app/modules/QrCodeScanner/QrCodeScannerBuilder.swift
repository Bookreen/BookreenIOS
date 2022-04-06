import Foundation
import UIKit

struct QrCodeScannerResult {
    let code: String
}

final class QrCodeScannerBuilder {
    
    private init() {}
    
    static func make(callback: @escaping (QrCodeScannerResult) -> Void) -> QrCodeScannerViewController {
        let storyboard = UIStoryboard(name: "QrCodeScanner", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QrCodeScannerViewController") as! QrCodeScannerViewController
        viewController.callback = callback
        return viewController
    }
}
