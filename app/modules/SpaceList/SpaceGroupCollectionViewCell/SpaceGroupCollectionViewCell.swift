import UIKit

protocol SpaceGroupCollectionViewCellDelegate: AnyObject {
    func spaceGroupCollectionViewCell(_ view: SpaceGroupCollectionViewCell, spaceGroup: SearchBookingResponse)
    func spaceGroupCollectionViewCell(_ view: SpaceGroupCollectionViewCell, didSelectedSpace: SpaceModel)
}

class SpaceGroupCollectionViewCell: UICollectionViewCell {

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    class var reuseIdentifier: String {
        return "SpaceGroupCollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "SpaceGroupCollectionViewCell"
    }
    
    private var _spaceGroup: SearchBookingResponse?
    
    var spaceGroup: SearchBookingResponse? {
        get {
            return self._spaceGroup
        }
        set(value) {
            self._spaceGroup = value
            guard let spaceGroup = self._spaceGroup else {
                return
            }
            self.labelTitle.text = spaceGroup.groupName ?? "Diğer"
            self.collectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
        
    var delegate: SpaceGroupCollectionViewCellDelegate?
    var spaceHorizontalCollectionViewCellDelegate: SpaceHorizontalCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        self.configureCollectionView()
        
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 232))
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: (self.frame.width - 24) / 2, height: 168)
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.isPagingEnabled = true
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let nib = UINib(nibName: SpaceHorizontalCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: SpaceHorizontalCollectionViewCell.reuseIdentifier)

    }
    
    @IBAction func pressedButtonSelect(_ sender: UIButton) {
        if let group = self._spaceGroup {
            self.delegate?.spaceGroupCollectionViewCell(self, spaceGroup: group)
        }
    }
}

extension SpaceGroupCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let group = self._spaceGroup {
            let occasions = group.occasions ?? []
            let row = occasions[indexPath.row]
            self.delegate?.spaceGroupCollectionViewCell(self, didSelectedSpace: row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self._spaceGroup?.occasions ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let occasions = self._spaceGroup?.occasions, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceHorizontalCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? SpaceHorizontalCollectionViewCell {
            cell.space = occasions[indexPath.row]
            cell.delegate = self.spaceHorizontalCollectionViewCellDelegate
            return cell
        }
        return UICollectionViewCell()
    }
}
