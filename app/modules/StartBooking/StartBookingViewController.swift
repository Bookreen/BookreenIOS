import Foundation
import UIKit

final class StartBookingViewController: AppViewController {
    
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var imageViewDate: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewTime: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageViewSpace: UIImageView!
    @IBOutlet weak var labelSpace: UILabel!
    
    @IBOutlet weak var buttonStartBooking: UIButton!
    
    var booking: BookingModel?
    var callback: ((StartBookingViewOutput) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelQuestion.font = .boldSystemFont(ofSize: 14)
        self.labelQuestion.textColor = UIColor.label
        
        self.labelQuestion.text = "checkInReservation".localized()
        
        self.labelDate.font = .systemFont(ofSize: 14)
        self.labelDate.textColor = UIColor.label
        
        self.labelSpace.font = .systemFont(ofSize: 14)
        self.labelSpace.textColor = UIColor.label
        
        self.labelTime.font = .systemFont(ofSize: 14)
        self.labelTime.textColor = UIColor.label
        
        self.imageViewDate.tintColor = UIColor.lightGray
        self.imageViewSpace.tintColor = UIColor.lightGray
        self.imageViewTime.tintColor = UIColor.lightGray
        
        self.buttonStartBooking.layer.cornerRadius = 8
        buttonStartBooking.backgroundColor = ColorPalette.shared.accentColor.withAlphaComponent(0.2)
        self.buttonStartBooking.setTitle("start".localized(), for: .normal)
        self.buttonStartBooking.titleLabel?.font = .boldSystemFont(ofSize: 14)
        self.buttonStartBooking.setTitleColor(ColorPalette.shared.accentColor, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parseData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func presssedButtonStartBooking(_ sender: UIButton) {
        if let _booking = self.booking {
            self.dismiss(animated: true, completion: nil)
            self.callback?(.startBooking(_booking))
        } else {
            self.dismiss(animated: true, completion: nil)
            self.callback?(.dismiss)
        }
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.dismiss)
    }
    
    private func parseData() {
        if let _booking = self.booking {
            self.labelDate.text = _booking.planDate ?? ""
            self.labelTime.text = "\(_booking.startTime ?? "") - \(_booking.endTime ?? "")"
            self.labelSpace.text = _booking.spaceName ?? ""
        } else {
            self.labelDate.text = ""
            self.labelTime.text = ""
            self.labelSpace.text = ""
        }
    }
}
