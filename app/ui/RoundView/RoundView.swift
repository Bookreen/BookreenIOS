import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = CGFloat(exactly: 0)! {
        didSet {
            self.setupView()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.cornerRadius
    }
}
