import Foundation
import UIKit

enum AlertType {
    case information
    case success
    case warning
    case error
}

final class CustomAlertViewController: AppViewController {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonOk: UIButton!
    
    var alertType: AlertType = .information
    var message: String = ""
    var buttonTitle: String = ""
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.imageViewIcon.tintColor = .clear
        self.imageViewIcon.backgroundColor = .clear
        switch self.alertType {
        case .error:
            self.imageViewIcon.image = UIImage(named: "error")
        case .information:
            self.imageViewIcon.image = UIImage(named: "info")
        case .success:
            self.imageViewIcon.image = UIImage(named: "success")
        case .warning:
            self.imageViewIcon.image = UIImage(named: "warning")
        }
        self.labelMessage.text = message
        self.buttonOk.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func pressedButtonOk(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.completion?()
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.completion?()
    }
}
