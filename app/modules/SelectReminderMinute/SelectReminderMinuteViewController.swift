import Foundation
import UIKit

final class SelectReminderMinuteViewController: AppViewController {
    
    var reminder: Int = 15
    var callback: ((Int) -> Void)?
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var label15: UILabel!
    @IBOutlet weak var label30: UILabel!
    @IBOutlet weak var label45: UILabel!
    @IBOutlet weak var label60: UILabel!
    
    
    @IBOutlet weak var view60: UIView!
    @IBOutlet weak var view45: UIView!
    @IBOutlet weak var view30: UIView!
    @IBOutlet weak var view15: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = S.pleaseSelectReminderTime.localized()

        let min=S.minutesShortly.localized()
        ["15":label15,"30":label30,"45":label45,"60":label60]
            .forEach {
                $0.value?.text="\($0.key) \(min)"
            }
        
        [view15:#selector(pressedButton15),
         view30:#selector(pressedButton30),
         view45:#selector(pressedButton45),
         view60:#selector(pressedButton60)]
            .forEach {
                $0.key?.isUserInteractionEnabled=true
                $0.key?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: $0.value))
            }
        
    }
    
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func pressedButton15() {
        self.dismiss(animated: true, completion: nil)
        self.callback?(15)
    }
    
    @objc private func pressedButton30() {
        self.dismiss(animated: true, completion: nil)
        self.callback?(30)
    }
    
    @objc private func pressedButton45() {
        self.dismiss(animated: true, completion: nil)
        self.callback?(45)
    }
    
    @objc private func pressedButton60() {
        self.dismiss(animated: true, completion: nil)
        self.callback?(60)
    }
}
