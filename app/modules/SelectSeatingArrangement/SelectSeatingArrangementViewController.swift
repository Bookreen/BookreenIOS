import Foundation
import UIKit

final class SelectSeatingArrangementViewController: AppViewController {
    
    private let squareTable = 2110
    private let rectangularTable = 2111
    private let roundTable = 2112
    private let triangleTable = 2113
    private let ovalTable = 3111
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageViewType1: UIImageView!
    @IBOutlet weak var imageViewType2: UIImageView!
    @IBOutlet weak var imageViewType3: UIImageView!
    @IBOutlet weak var imageViewType4: UIImageView!
    @IBOutlet weak var imageViewType5: UIImageView!
    
    @IBOutlet weak var selectedViewType1: UIView!
    @IBOutlet weak var selectedViewType2: UIView!
    @IBOutlet weak var selectedViewType3: UIView!
    @IBOutlet weak var selectedViewType4: UIView!
    @IBOutlet weak var selectedViewType5: UIView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var callback: ((Int) -> Void)?
    
    var type: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelTitle.text = "seatingArrangement".localized()
        
        self.buttonSubmit.setTitle("ok".localized(), for: .normal)
        self.buttonSubmit.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
        
        self.buttonSubmit.layer.cornerRadius = 8
        
        self.imageViewType1.image = UIImage(named: "desk1")!
        self.imageViewType2.image = UIImage(named: "desk2")!
        self.imageViewType3.image = UIImage(named: "desk3")!
        self.imageViewType4.image = UIImage(named: "desk4")!
        self.imageViewType5.image = UIImage(named: "desk5")!
        
        self.selectedViewType1.layer.cornerRadius = 8
        self.selectedViewType1.backgroundColor = ColorPalette.shared.accentColor
        
        self.selectedViewType2.layer.cornerRadius = 8
        self.selectedViewType2.backgroundColor = ColorPalette.shared.accentColor
        
        self.selectedViewType3.layer.cornerRadius = 8
        self.selectedViewType3.backgroundColor = ColorPalette.shared.accentColor
        
        self.selectedViewType4.layer.cornerRadius = 8
        self.selectedViewType4.backgroundColor = ColorPalette.shared.accentColor
        
        self.selectedViewType5.layer.cornerRadius = 8
        self.selectedViewType5.backgroundColor = ColorPalette.shared.accentColor
    }
    
    private func update() {
        switch self.type {
        case self.squareTable:
            self.selectedViewType1.alpha = 1
            self.selectedViewType2.alpha = 0
            self.selectedViewType3.alpha = 0
            self.selectedViewType4.alpha = 0
            self.selectedViewType5.alpha = 0
        case self.rectangularTable:
            self.selectedViewType1.alpha = 0
            self.selectedViewType2.alpha = 1
            self.selectedViewType3.alpha = 0
            self.selectedViewType4.alpha = 0
            self.selectedViewType5.alpha = 0
        case self.roundTable:
            self.selectedViewType1.alpha = 0
            self.selectedViewType2.alpha = 0
            self.selectedViewType3.alpha = 1
            self.selectedViewType4.alpha = 0
            self.selectedViewType5.alpha = 0
        case self.triangleTable:
            self.selectedViewType1.alpha = 0
            self.selectedViewType2.alpha = 0
            self.selectedViewType3.alpha = 0
            self.selectedViewType4.alpha = 1
            self.selectedViewType5.alpha = 0
        case self.ovalTable:
            self.selectedViewType1.alpha = 0
            self.selectedViewType2.alpha = 0
            self.selectedViewType3.alpha = 0
            self.selectedViewType4.alpha = 0
            self.selectedViewType5.alpha = 1
        default:
            self.selectedViewType1.alpha = 0
            self.selectedViewType2.alpha = 0
            self.selectedViewType3.alpha = 0
            self.selectedViewType4.alpha = 0
            self.selectedViewType5.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pressedButtonDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedButtonSubmit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.callback?(self.type)
    }
    
    @IBAction func pressedButtonType1(_ sender: UIButton) {
        if self.type == self.squareTable {
            self.type = 0
        } else {
            self.type = self.squareTable
        }
        self.update()
    }
    
    @IBAction func pressedButtonType2(_ sender: UIButton) {
        if self.type == self.rectangularTable {
            self.type = 0
        } else {
            self.type = self.rectangularTable
        }
        self.update()
    }
    
    @IBAction func pressedButtonType3(_ sender: UIButton) {
        if self.type == self.roundTable {
            self.type = 0
        } else {
            self.type = self.roundTable
        }
        self.update()
    }
    
    @IBAction func pressedButtonType4(_ sender: UIButton) {
        if self.type == self.triangleTable {
            self.type = 0
        } else {
            self.type = self.triangleTable
        }
        self.update()
    }
    
    @IBAction func pressedButtonType5(_ sender: UIButton) {
        if self.type == self.ovalTable {
            self.type = 0
        } else {
            self.type = self.ovalTable
        }
        self.update()
    }
}
