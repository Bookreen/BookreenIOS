import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var labelTimeRange: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    private var _booking: BookingModel?
    var listener:((BookingModel)->Void)?
    var isSelectedBooking: Bool = false {
        didSet {
            self.configureView()
        }
    }
    
    var booking: BookingModel? {
        get {
            return self._booking
        }
        set(value) {
            self._booking = value
            guard let booking = self._booking else {
                return
            }
            
            self.labelTitle.text = booking.subject
            self.labelTime.text = booking.startTime ?? ""
            self.labelTimeRange.text = "\(booking.startTime ?? "") - \(booking.endTime ?? "")"
            self.labelDescription.text = booking.spaceName ?? ""
            self.labelAddress.text = "\(booking.campusName ?? ""), \(booking.buildingName ?? ""), \(booking.floorName ?? "")"
            
            self.editButton.isHidden = !(booking.bookingStatus == .checkinWaitingEvents || booking.bookingStatus == .upcomingEvents)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 4
        
        self.viewTime.layer.borderWidth = 1
        self.viewTime.layer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor

        self.labelTime.font = .systemFont(ofSize: 12)
        self.labelTimeRange.font = .systemFont(ofSize: 12)
        self.labelTitle.font = .systemFont(ofSize: 12)
        self.labelDescription.font = .systemFont(ofSize: 12)
        self.labelAddress.font = .italicSystemFont(ofSize: 10)
        editButton.setTitle(S.edit.localized(), for: .normal)
        self.isSelected = false
    }
    
    private func configureView() {
        if self.isSelectedBooking {
            self.containerView.backgroundColor = ColorPalette.shared.accentColor
            self.labelTimeRange.textColor = ColorPalette.shared.colorWhite
            self.labelTitle.textColor = ColorPalette.shared.colorWhite
            self.labelDescription.textColor = ColorPalette.shared.colorWhite
            self.labelAddress.textColor = ColorPalette.shared.colorWhite
            self.editButton.setTitleColor(.white, for: .normal)
        } else {
            self.containerView.backgroundColor = UIColor.secondarySystemBackground
            self.labelTimeRange.textColor = UIColor.label
            self.labelTitle.textColor = UIColor.label
            self.labelDescription.textColor = UIColor.label
            self.labelAddress.textColor = UIColor.secondaryLabel
            self.editButton.setTitleColor(ColorPalette.shared.accentColor, for: .normal)
        }
    }

    @IBAction func editTap(_ sender: Any) {
        if let b=booking{
            listener?.self(b)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
