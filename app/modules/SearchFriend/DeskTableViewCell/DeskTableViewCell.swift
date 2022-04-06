import UIKit

class DeskTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelOrganizer: UILabel!
    @IBOutlet weak var labelDesk: UILabel!
    @IBOutlet weak var labelCampus: UILabel!
    @IBOutlet weak var labelBuilding: UILabel!
    @IBOutlet weak var labelFloor: UILabel!
    
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
            
            self.labelTitle.text = "tableReservation".localized()
            self.labelOrganizer.text = booking.organizer ?? ""
            self.labelCampus.text = booking.campusName ?? ""
            self.labelBuilding.text = booking.buildingName ?? ""
            self.labelFloor.text = booking.floorName ?? ""
            self.labelDesk.text = booking.locationName ?? ""
            
            let planDateFormatter = DateFormatter()
            planDateFormatter.dateFormat = "yyyy-MM-dd"
            if let planDate = planDateFormatter.date(from: booking.planDate ?? "") {
                
                let monthDateFormatter = DateFormatter()
                monthDateFormatter.locale = Locale(identifier: Locale.current.identifier)
                monthDateFormatter.dateFormat = "LLL"
                let nameOfMonth = monthDateFormatter.string(from: planDate)
                
                let nameOfDayDateFormatter = DateFormatter()
                nameOfDayDateFormatter.locale = Locale(identifier: Locale.current.identifier)
                nameOfDayDateFormatter.dateFormat = "EEEE"
                let nameOfDay = nameOfDayDateFormatter.string(from: planDate)

                let dayDateFormatter = DateFormatter()
                dayDateFormatter.locale = Locale(identifier: Locale.current.identifier)
                dayDateFormatter.dateFormat = "dd"
                let day = dayDateFormatter.string(from: planDate)
                
                let date = "\(booking.startTime ?? "") - \(booking.endTime ?? ""), \(nameOfDay), \(day) \(nameOfMonth)"
                self.labelDate.text = date

            } else {
                let date = "\(booking.startTime ?? "") - \(booking.endTime ?? "")"
                self.labelDate.text = date
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.borderColor = ColorPalette.shared.colorGrey200.cgColor
        self.viewContainer.layer.borderWidth = 1
        self.viewContainer.layer.cornerRadius = 8
        
        self.viewLine.alpha = 0.7
        self.viewLine.backgroundColor = ColorPalette.shared.colorBlack
        
        self.imageViewIcon.tintColor = ColorPalette.shared.colorBlack
        
        self.labelTitle.font = .boldSystemFont(ofSize: 16)
        self.labelTitle.textColor = ColorPalette.shared.colorBlack
        
        self.labelDate.font = .italicSystemFont(ofSize: 14)
        self.labelDate.textColor = ColorPalette.shared.colorGrey700
        
        self.labelCampus.font = .systemFont(ofSize: 14)
        self.labelCampus.textColor = ColorPalette.shared.colorGrey700
        
        self.labelBuilding.font = .systemFont(ofSize: 14)
        self.labelBuilding.textColor = ColorPalette.shared.colorGrey700
        
        self.labelFloor.font = .systemFont(ofSize: 14)
        self.labelFloor.textColor = ColorPalette.shared.colorGrey700
        
        self.labelOrganizer.font = .systemFont(ofSize: 14)
        self.labelOrganizer.textColor = ColorPalette.shared.colorGrey700
        
        self.labelDesk.font = .systemFont(ofSize: 14)
        self.labelDesk.textColor = ColorPalette.shared.colorGrey700
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
