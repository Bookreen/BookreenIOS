import Foundation
import UIKit
import SDWebImage

final class InstantBookingViewController: AppViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var labelSpace: UILabel!
    @IBOutlet weak var labelReservation: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonThirty: UIButton!
    @IBOutlet weak var buttonFourtyFive: UIButton!
    @IBOutlet weak var buttonSixty: UIButton!
    @IBOutlet weak var buttonOneHundredAndTwenty: UIButton!
    
    var space: SpaceModel?
    
    var callback: ((InstantBookingViewOutput) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.contentMode = .scaleToFill
        self.imageView.backgroundColor = .clear
        self.viewHeader.backgroundColor = ColorPalette.shared.accentColor
        
        self.labelHeader.textColor = ColorPalette.shared.colorWhite
        self.labelHeader.font = .boldSystemFont(ofSize: 14)
        self.labelHeader.text = "instantReservation".localized()
        
        self.viewAddress.backgroundColor = ColorPalette.shared.colorBlack
        self.viewAddress.alpha = 0.5
        
        self.labelAddress.textColor = ColorPalette.shared.colorWhite
        self.labelAddress.font = .systemFont(ofSize: 14)
        
        self.viewSpace.backgroundColor = ColorPalette.shared.colorBlack
        self.viewSpace.alpha = 0.5
        
        self.labelSpace.textColor = ColorPalette.shared.colorWhite
        self.labelSpace.font = .systemFont(ofSize: 14)
        
        self.labelReservation.textColor = ColorPalette.shared.colorGrey700
        self.labelReservation.font = .systemFont(ofSize: 14)
        self.labelReservation.text = "reserve".localized()
        
        self.configureButton(self.buttonThirty, title: "30", tag: 1)
        self.configureButton(self.buttonFourtyFive, title: "45", tag: 2)
        self.configureButton(self.buttonSixty, title: "60", tag: 3)
        self.configureButton(self.buttonOneHundredAndTwenty, title: "120", tag: 4)
        self.parseData()
    }
    
    private func parseData() {
        if let _space = self.space {
            let campusName = _space.campusName ?? ""
            let buildingName = _space.buildingName ?? ""
            let floorName = _space.floorName ?? ""
            let spaceTitle = _space.name ?? ""
            let mediaPath = _space.mediaFilePath ?? ""
            if mediaPath.count > 0 {
                let urlAsString = "https://space.bookreen.com\(mediaPath)"
                let url = URL(string: urlAsString)
                self.imageView.sd_setImage(with: url)
            }
            self.labelSpace.text = spaceTitle
            self.labelAddress.text = "\(campusName), \(buildingName), \(floorName)"
        } else {
            self.labelAddress.text = ""
            self.labelSpace.text = ""
        }
    }
    
    private func configureButton(_ button: UIButton, title: String, tag: Int) {
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.backgroundColor = ColorPalette.shared.accentColor
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
        button.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(.dismiss)
    }
    @IBAction func pressedButton(_ sender: UIButton) {
        if let _space = self.space {
            switch sender.tag {
            case self.buttonThirty.tag:
                self.dismiss(animated: true, completion: nil)
                self.callback?(.createReservation(InstantBookingOutput(space: _space, time: 30)))
            case self.buttonFourtyFive.tag:
                self.dismiss(animated: true, completion: nil)
                self.callback?(.createReservation(InstantBookingOutput(space: _space, time: 45)))
            case self.buttonSixty.tag:
                self.dismiss(animated: true, completion: nil)
                self.callback?(.createReservation(InstantBookingOutput(space: _space, time: 60)))
            case self.buttonOneHundredAndTwenty.tag:
                self.dismiss(animated: true, completion: nil)
                self.callback?(.createReservation(InstantBookingOutput(space: _space, time: 120)))
            default:
                print("unknown")
            }
        }
    }
}
