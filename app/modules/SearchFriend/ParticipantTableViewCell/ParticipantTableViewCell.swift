import UIKit

protocol ParticipantTableViewCellDelegate {
    func pressedParticipantTableViewCell(_ sender: ParticipantTableViewCell)
}

class ParticipantTableViewCell: UITableViewCell {

    var delegate: ParticipantTableViewCellDelegate?
    
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var viewRadius: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonChoose: UIButton!
    
    private var _participant: ParticipantModel?
    
    var participant: ParticipantModel? {
        get {
            return self._participant
        }
        set(value) {
            self._participant = value
            guard let participant = self._participant else {
                return
            }
            
            
            
            let placeHolderImage = UIImage(named: "placeholder_person")
            self.labelName.text = participant.fullname
            self.labelEmail.text = participant.email
            let profilePhoto = participant.profilePhoto ?? ""
            if let _data = Data(base64Encoded: profilePhoto) {
                if let profilePhotoImage = UIImage(data: _data) {
                    self.imageViewProfilePhoto.image = profilePhotoImage
                    self.imageViewProfilePhoto.tintColor = .clear
                } else {
                    self.imageViewProfilePhoto.tintColor = ColorPalette.shared.colorBlack
                    self.imageViewProfilePhoto.image = placeHolderImage
                }
            } else {
                self.imageViewProfilePhoto.tintColor = ColorPalette.shared.colorBlack
                self.imageViewProfilePhoto.image = placeHolderImage
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewRadius.layer.borderColor = UIColor.separator.cgColor
        self.viewRadius.layer.borderWidth = 1
        self.viewRadius.layer.cornerRadius = 8
        
        self.imageViewProfilePhoto.contentMode = .scaleToFill
        self.imageViewProfilePhoto.layer.cornerRadius = self.imageViewProfilePhoto.frame.width / 2
        self.imageViewProfilePhoto.layer.borderWidth = 1
        self.imageViewProfilePhoto.layer.borderColor = UIColor.separator.cgColor
        
        self.buttonChoose.setTitle("choose".localized().uppercased(), for: .normal)
        
    }

    @IBAction func pressedButtonChoose(_ sender: UIButton) {
        self.delegate?.pressedParticipantTableViewCell(self)
    }
    
}
