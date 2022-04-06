import Foundation
import UIKit
import StepSlider

final class ExtendBookingViewController: AppViewController {
    
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var sliderView: StepSlider!
    
    @IBOutlet weak var labelExtendedTime: UILabel!
    
    @IBOutlet weak var buttonExtendBooking: UIButton!
    
    var booking: BookingModel?
    var callback: ((ExtendBookingViewOutput) -> Void)?
    
    var activeTimeExtented: Int = 30 {
        didSet {
            self.labelExtendedTime.text = "extendMinutesFormat".localized().replacingOccurrences(of: "[%minutes%]", with: "\(self.activeTimeExtented)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelQuestion.font = .boldSystemFont(ofSize: 16)
        self.labelQuestion.text = S.extendTime.localized()
        
        self.labelExtendedTime.font = .boldSystemFont(ofSize: 14)
        self.labelExtendedTime.textColor = ColorPalette.shared.accentColor
        
        self.sliderView.maxCount = 8
        self.sliderView.index = 1
        self.sliderView.trackColor = UIColor.secondaryLabel
        self.sliderView.isDotsInteractionEnabled = true
        self.sliderView.sliderCircleColor = ColorPalette.shared.accentColor
        self.sliderView.tintColor = ColorPalette.shared.accentColor
        self.sliderView.addTarget(self, action: #selector(changedSlider), for: .valueChanged)
        self.buttonExtendBooking.layer.cornerRadius = 8
        buttonExtendBooking.backgroundColor = ColorPalette.shared.accentColor.withAlphaComponent(0.2)
        self.buttonExtendBooking.setTitle("extend".localized(), for: .normal)
        self.buttonExtendBooking.titleLabel?.font = .boldSystemFont(ofSize: 14)
        self.buttonExtendBooking.setTitleColor(ColorPalette.shared.accentColor, for: .normal)
        
        self.activeTimeExtented = 30
    }
        
    @IBAction func presssedButtonExtendBooking(_ sender: UIButton) {
        if let _booking = self.booking {
            self.dismiss(animated: true, completion: nil)
            self.callback?(.extendBooking(ExtendBookingOutput(bookingModel: _booking, extendTime: activeTimeExtented)))
        } else {
            self.dismiss(animated: true, completion: nil)
            self.callback?(.dismiss)
        }
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.dismiss)
    }
    
    @objc func changedSlider() {
        let index = self.sliderView.index
        if index==0{
            self.activeTimeExtented=0
        }else{
            self.activeTimeExtented = Int((index + 1) * 15)
        }
    }
}


