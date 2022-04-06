import Foundation
import UIKit

final class CalendarItemView: UIView {
    
    fileprivate lazy var labelDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    fileprivate lazy var labelDayAsInt: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.label
        return label
    }()
    
    fileprivate lazy var viewSelected: CustomGradientView = {
        let view = CustomGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.endColor = ColorPalette.shared.colorPurple100
        view.startColor = ColorPalette.shared.accentColor
        return view
    }()
    
    fileprivate lazy var viewHasExistsBooking: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 4
        view.alpha = 0.0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    var day: Day? = nil {
        didSet {
            self.updateUI()
        }
    }
    
    var hasExistsBooking: Bool = false {
        didSet {
            self.viewHasExistsBooking.alpha = self.hasExistsBooking ? 1.0 : 0.0
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(self.viewSelected)
        self.addSubview(self.labelDay)
        self.addSubview(self.labelDayAsInt)
        self.addSubview(self.viewHasExistsBooking)
        
        NSLayoutConstraint.activate(
            [
                self.viewSelected.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
                self.viewSelected.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                self.viewSelected.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
                self.viewSelected.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                self.labelDay.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
                self.labelDay.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.bottomAnchor.constraint(equalTo: self.labelDayAsInt.bottomAnchor, constant: 18),
                self.labelDayAsInt.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.viewHasExistsBooking.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                self.viewHasExistsBooking.heightAnchor.constraint(equalToConstant: 3),
                self.viewHasExistsBooking.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                self.viewHasExistsBooking.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
                
            ]
        )
        self.updateUI()
    }
    
    private func updateUI() {
        if let _day = self.day {
            self.labelDay.text = _day.daySummary
            self.labelDayAsInt.text = "\(_day.dayOfMonth)"
            
            self.viewSelected.layer.cornerRadius = 8
            self.viewSelected.alpha = _day.isSelected ? 1.0 : 0.0
            
            self.labelDay.textColor = _day.isSelected ? ColorPalette.shared.colorWhite : UIColor.label
            self.labelDayAsInt.textColor = _day.isSelected ? ColorPalette.shared.colorWhite : UIColor.secondaryLabel

        }
    }
}
