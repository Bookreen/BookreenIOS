import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var roundView: RoundView!
    
    private var _color: String = ""
    
    var color: String {
        get {
            return self._color
        }
        set(value) {
            self._color = value
            self.roundView.backgroundColor = self._color.hexStringToUIColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundView.cornerRadius = self.roundView.frame.width / 2
    }
}
