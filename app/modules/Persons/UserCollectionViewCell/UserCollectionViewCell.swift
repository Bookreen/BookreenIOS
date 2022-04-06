import UIKit

protocol UserCollectionViewCellDelegate: AnyObject {
    func userCollectionViewCell(_ view: UserCollectionViewCell, follow: EmployeeModel)
    func userCollectionViewCell(_ view: UserCollectionViewCell, unfollow: EmployeeModel)
}

class UserCollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String {
        return "UserCollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "UserCollectionViewCell"
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    var delegate: UserCollectionViewCellDelegate?
    
    private var _employee: EmployeeModel?
    var isFavorite: Bool = false {
        didSet {
            self.configureActionButtons()
        }
    }
    
    var employee: EmployeeModel? {
        get {
            return self._employee
        }
        set(value) {
            self._employee = value
            guard let employee = self._employee else {
                return
            }
            
            let placeHolderImage = UIImage(named: "placeholder_person")
            self.labelNameSurname.text = "\(employee.name ?? "") \(employee.surname ?? "")"
            self.labelEmail.text = employee.email ?? ""
            let profilePhoto = employee.profilePhoto ?? ""
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
    
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelNameSurname: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    @IBOutlet weak var viewAddUserToFollowList: UIView!
    @IBOutlet weak var imageViewAddUserToFollowListIcon: UIImageView!
    @IBOutlet weak var labelAddUserToFollowList: UILabel!
    @IBOutlet weak var buttonAddUserToFollowList: UIButton!
    
    @IBOutlet weak var viewRemoveUserFromFollowList: UIView!
    @IBOutlet weak var imageViewRemoveUserFromFollowListIcon: UIImageView!
    @IBOutlet weak var labelRemoveUserFromFollowList: UILabel!
    @IBOutlet weak var buttonRemoveUserFromFollowList: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewLine.backgroundColor = UIColor.separator
        
        self.imageViewProfilePhoto.contentMode = .scaleToFill
        self.imageViewProfilePhoto.layer.cornerRadius = self.imageViewProfilePhoto.frame.width / 2
        self.imageViewProfilePhoto.layer.borderWidth = 1
        self.imageViewProfilePhoto.layer.borderColor = UIColor.separator.cgColor
        
        self.labelNameSurname.text = ""
        
        self.labelEmail.text = ""
        
        self.viewAddUserToFollowList.backgroundColor = .clear
        self.viewAddUserToFollowList.layer.borderWidth = 1
        self.viewAddUserToFollowList.layer.borderColor = UIColor.separator.cgColor
        self.viewAddUserToFollowList.layer.cornerRadius = 4
        
        self.imageViewAddUserToFollowListIcon.tintColor = ColorPalette.shared.accentColor
        self.imageViewAddUserToFollowListIcon.image = UIImage(named: "add")!
        
        self.labelAddUserToFollowList.font = .boldSystemFont(ofSize: 14)
        self.labelAddUserToFollowList.textColor = ColorPalette.shared.accentColor
        
        self.viewRemoveUserFromFollowList.backgroundColor = .clear
        self.viewRemoveUserFromFollowList.layer.borderWidth = 1
        self.viewRemoveUserFromFollowList.layer.borderColor = UIColor.separator.cgColor
        self.viewRemoveUserFromFollowList.layer.cornerRadius = 4
        
        self.imageViewRemoveUserFromFollowListIcon.tintColor = ColorPalette.shared.accentColor
        self.imageViewRemoveUserFromFollowListIcon.image = UIImage(named: "cancel")!
        
        self.labelRemoveUserFromFollowList.font = .boldSystemFont(ofSize: 14)
        self.labelRemoveUserFromFollowList.textColor = ColorPalette.shared.accentColor
        
        self.configureActionButtons()
    }
    
    private func configureActionButtons() {
        if self.isFavorite {
            self.hideViewAddUserToFollowList()
            self.showViewRemoveUserFromFollowList()
        } else {
            self.showViewAddUserToFollowList()
            self.hideViewRemoveUserFromFollowList()
        }
    }
    
    private func showViewRemoveUserFromFollowList() {
        self.viewRemoveUserFromFollowList.alpha = 1
        self.viewRemoveUserFromFollowList.isUserInteractionEnabled = true
        
        self.buttonRemoveUserFromFollowList.alpha = 1
        self.buttonRemoveUserFromFollowList.isUserInteractionEnabled = true
        self.labelRemoveUserFromFollowList.text = "unfollow".localized()
    }
    
    private func hideViewRemoveUserFromFollowList() {
        self.viewRemoveUserFromFollowList.alpha = 0
        self.viewRemoveUserFromFollowList.isUserInteractionEnabled = false
        self.buttonRemoveUserFromFollowList.alpha = 0
        self.buttonRemoveUserFromFollowList.isUserInteractionEnabled = false
        self.labelRemoveUserFromFollowList.text = ""
    }
    
    private func showViewAddUserToFollowList() {
        self.viewAddUserToFollowList.alpha = 1
        self.viewAddUserToFollowList.isUserInteractionEnabled = true
        self.buttonAddUserToFollowList.alpha = 1
        self.buttonAddUserToFollowList.isUserInteractionEnabled = true
        self.labelAddUserToFollowList.text = "follow".localized()
    }
    
    private func hideViewAddUserToFollowList() {
        self.viewAddUserToFollowList.alpha = 0
        self.viewAddUserToFollowList.isUserInteractionEnabled = false
        self.buttonAddUserToFollowList.alpha = 0
        self.buttonAddUserToFollowList.isUserInteractionEnabled = false
        self.labelAddUserToFollowList.text = ""
    }
    
    @IBAction func pressedButtonAddUserToFollowList(_ sender: UIButton) {
        if let employee = self._employee {
            self.delegate?.userCollectionViewCell(self, follow: employee)
        }
    }
    
    @IBAction func pressedButtonRemoveUserFromFollowList(_ sender: UIButton) {
        if let employee = self._employee {
            self.delegate?.userCollectionViewCell(self, unfollow: employee)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = targetSize.width
        let size = CGSize(width: targetSize.width, height: targetSize.height)
        return contentView.systemLayoutSizeFitting(size)
    }
    
}
