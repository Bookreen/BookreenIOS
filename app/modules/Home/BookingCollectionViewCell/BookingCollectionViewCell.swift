import UIKit

protocol BookingCollectionViewCellDelegate: AnyObject {
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, cancelBooking: BookingModel)
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, extendBooking: BookingModel)
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, startBooking: BookingModel)
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, endBooking: BookingModel)
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, editBooking: BookingModel)

}

class BookingCollectionViewCell: UICollectionViewCell {

    var delegate: BookingCollectionViewCellDelegate?
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewLocation: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelBookingTitle: UILabel!
    @IBOutlet weak var labelDesk: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonExtend: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonEnd: UIButton!
    @IBOutlet weak var viewTriangle: UIView!
    @IBOutlet weak var imageViewTriangle: UIImageView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    class var reuseIdentifier: String {
        return "BookingCollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "BookingCollectionViewCell"
    }
    
    private var _booking: BookingModel?
    
    var booking: BookingModel? {
        get {
            return self._booking
        }
        set(value) {
            self._booking = value
            guard let booking = self._booking else {
                return
            }
            self.labelAddress.text = "\(booking.campusName ?? "") / \(booking.buildingName ?? "")"
            self.labelBookingTitle.text = value?.subject?.isEmpty == true ? S.yourTableReservation.localized() : value?.subject
            
            self.labelTime.text = "\(booking.startTime ?? "") - \(booking.endTime ?? "")"

            let desk = booking.spaceName ?? ""
            let floor = booking.floorName ?? ""
            self.labelDesk.attributedText = self.configureDesk(desk: desk, floor: floor)
            
            
            self.buttonCancel.alpha = 0
            self.buttonCancel.isUserInteractionEnabled = false
            
            self.buttonStart.alpha = 0
            self.buttonStart.isUserInteractionEnabled = false
            
            self.buttonEnd.alpha = 0
            self.buttonEnd.isUserInteractionEnabled = false
            
            self.buttonExtend.alpha = 0
            self.buttonExtend.isUserInteractionEnabled = false
            
            self.editButton.alpha = 0
            self.editButton.isUserInteractionEnabled = false
            
            switch booking.bookingStatus {
            case .checkinWaitingEvents:
                self.imageViewTriangle.image = UIImage(named: "item_background_waiting")!
                self.imageViewIcon.image = UIImage(named: "clock")!
                self.buttonStart.alpha = 1
                self.buttonStart.isUserInteractionEnabled = true
                self.buttonCancel.alpha = 1
                self.buttonCancel.isUserInteractionEnabled = true
                editButton.isUserInteractionEnabled=true
                editButton.alpha=1.0
            case .upcomingEvents:
                self.imageViewTriangle.image = UIImage(named: "item_background_upcoming")!
                self.imageViewIcon.image = UIImage(named: "upcomingIcon")!
                self.buttonCancel.alpha = 1
                self.buttonCancel.isUserInteractionEnabled = true
                editButton.isUserInteractionEnabled=true
                editButton.alpha=1.0
            case .ongoingEvents:
                self.imageViewTriangle.image = UIImage(named: "item_background_ongoing")!
                self.imageViewIcon.image = UIImage(named: "recycle")!
                self.buttonEnd.alpha = 1
                self.buttonEnd.isUserInteractionEnabled = true
                self.buttonExtend.alpha = 1
                self.buttonExtend.isUserInteractionEnabled = true
            case .notCheckedinEvents:
                self.imageViewTriangle.image = UIImage(named: "item_background_waiting")!
                self.imageViewIcon.image = UIImage(named: "clock")!
                self.buttonStart.alpha = 1
                self.buttonStart.isUserInteractionEnabled = true
                self.buttonCancel.alpha = 1
                self.buttonCancel.isUserInteractionEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewTriangle.layer.cornerRadius = 4
        self.imageViewTriangle.layer.cornerRadius = 4
       
        self.viewContainer.layer.cornerRadius = 10.0
        
        self.imageViewLocation.tintColor = UIColor.label
        
        self.labelAddress.textColor = UIColor.label
        self.labelAddress.font = .systemFont(ofSize: 14)
        
        self.labelTime.textColor = UIColor.secondaryLabel
        self.labelTime.font = .systemFont(ofSize: 14)
        
        self.labelBookingTitle.textColor = UIColor.label
        self.labelBookingTitle.font = .systemFont(ofSize: 14)
        
        self.labelDesk.textColor = UIColor.label
        self.labelDesk.font = .systemFont(ofSize: 14)
     
        
        [S.cancel:buttonCancel,S.start:buttonStart,S.finish:buttonEnd,S.extend:buttonExtend,"edit":editButton].forEach {
            $0.value?.layer.cornerRadius = 10.0
            $0.value?.backgroundColor = ColorPalette.shared.accentColor.withAlphaComponent(0.1)
            $0.value?.setTitleColor(UIColor.label, for: .normal)
            $0.value?.titleLabel?.font = .systemFont(ofSize: 14)
            $0.value?.setTitle($0.key.localized(), for: .normal)
        }
    }
    
    private func configureDesk(desk: String, floor: String) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(
            string: "\(desk), \(floor)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
            ]
        )
        mutableString.setColorForText(textForAttribute: desk, withColor: UIColor.label)
        mutableString.setFont(textForAttribute: desk, withFont: UIFont.boldSystemFont(ofSize:  16))
        return mutableString
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    @IBAction func pressedButtonCancelBooking(_ sender: UIButton) {
        if let _booking = self._booking {
            self.delegate?.bookingCollectionViewCell(self, cancelBooking: _booking)
        }
    }
    
    @IBAction func pressedButtonExtendBooking(_ sender: UIButton) {
        if let _booking = self._booking {
            self.delegate?.bookingCollectionViewCell(self, extendBooking: _booking)
        }
    }
    
    @IBAction func pressedButtonStartBooking(_ sender: UIButton) {
        if let _booking = self._booking {
            self.delegate?.bookingCollectionViewCell(self, startBooking: _booking)
        }
    }
    
    @IBAction func editButtontap(_ sender: Any) {
        if let _booking = self._booking {
            self.delegate?.bookingCollectionViewCell(self, editBooking: _booking)
        }
    }
    @IBAction func pressedButtonEndBooking(_ sender: UIButton) {
        if let _booking = self._booking {
            self.delegate?.bookingCollectionViewCell(self, endBooking: _booking)
        }
    }
}
