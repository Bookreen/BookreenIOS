import UIKit
import SDWebImage

protocol SpaceHorizontalCollectionViewCellDelegate: AnyObject {
    func spaceHorizontalCollectionViewCell(_ view: SpaceHorizontalCollectionViewCell, addFavorite: SpaceModel)
}

class SpaceHorizontalCollectionViewCell: UICollectionViewCell {

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    class var reuseIdentifier: String {
        return "SpaceHorizontalCollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "SpaceHorizontalCollectionViewCell"
    }
    
    private var _space: SpaceModel?
    
    var space: SpaceModel? {
        get {
            return self._space
        }
        set(value) {
            self._space = value
            guard let space = self._space else {
                return
            }
            self.labelSpaceName.text = space.name ?? ""
    
            if (space.isMyFavorite ?? "false") == "true" {
                self.imageViewFavorite.tintColor = ColorPalette.shared.accentColor
            } else {
                self.imageViewFavorite.tintColor = UIColor.black
            }
            
            self.labelUserCount.text = space.capacity ?? "0"
            let mediaPath = space.mediaFilePath ?? ""
            if mediaPath.count > 0 {
                let urlAsString = "https://space.bookreen.com\(mediaPath)"
                let url = URL(string: urlAsString)
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_meeting_room")!)
            } else {
                self.imageView.image = UIImage(named: "placeholder_meeting_room")!
            }
        }
    }
    
    var delegate: SpaceHorizontalCollectionViewCellDelegate?
    
    @IBOutlet weak var labelUserCount: UILabel!
    @IBOutlet weak var imageViewLayout: UIImageView!
    @IBOutlet weak var imageViewUsers: UIImageView!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelSpaceName: UILabel!
    @IBOutlet weak var viewShadow: RadiusView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageViewLayout.image = UIImage(named: "users")!
        self.imageViewUsers.image = UIImage(named: "users")!
        self.imageViewFavorite.image = UIImage(named: "favorite")!
        
        self.imageViewLayout.tintColor = ColorPalette.shared.colorWhite
        self.imageViewLayout.alpha = 0
        self.imageViewUsers.tintColor = ColorPalette.shared.colorWhite
        self.imageViewUsers.alpha = 0
        
        self.labelSpaceName.font = .systemFont(ofSize: 14)
        self.labelSpaceName.textColor = ColorPalette.shared.colorWhite
        
        self.labelUserCount.font = .systemFont(ofSize: 14)
        self.labelUserCount.textColor = ColorPalette.shared.colorWhite
        self.labelUserCount.alpha = 0
        
        self.viewShadow.backgroundColor = ColorPalette.shared.colorBlack
        self.viewShadow.alpha = 0.5
        
        self.viewContainer.layer.cornerRadius = 4
        self.viewContainer.layer.borderWidth = 1
        self.viewContainer.layer.borderColor = UIColor.separator.cgColor
        self.viewContainer.backgroundColor = .clear
        
        self.imageView.layer.cornerRadius = 4
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .clear
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: (targetSize.width - 24) / 2, height: 168))
    }
    
    @IBAction func pressedButtonAddFavorite(_ sender: UIButton) {
        if let space = self._space {
            self.delegate?.spaceHorizontalCollectionViewCell(self, addFavorite: space)
        }
    }
}
