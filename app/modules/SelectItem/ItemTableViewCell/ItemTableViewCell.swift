import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    private var _item: Item?
    
    var item: Item? {
        get {
            return self._item
        }
        set(value) {
            self._item = value
            guard let item = self._item else {
                self.labelTitle.text = ""
                return
            }
            self.labelTitle.text = item.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
