import UIKit

@IBDesignable
final class CustomIndicatorView: UIView {
    
    private let stackView = UIStackView()
    
    @IBInspectable
    var totalCount: Int = 0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var currentIndex: Int = 0 {
        didSet {
            self.createIndicators()
        }
    }
    
    @IBInspectable
    var activeBackgroundColor: UIColor = .clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var defaultBackgroundColor: UIColor = .clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = .clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var defaultBorderColor: UIColor = .clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var activeBorderWidth: CGFloat = 0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable
    var defaultBorderWidth: CGFloat = 0 {
        didSet {
            self.updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForInterfaceBuilder() {
        self.updateView()
    }
    
    private func updateView() {
        self.addSubview(self.stackView)
        self.backgroundColor = .clear
        self.stackView.backgroundColor = .clear
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.createIndicators()
    }
    
    private func createIndicators() {
        let indicatorViews: [UIView] = Array(0 ..< self.totalCount).map { _ in
            self.createIndicatorView()
        }
        
        self.stackView.removeAllArrangedSubviews()

        for (index, element) in indicatorViews.enumerated() {
            if index == currentIndex {
                // active
                element.subviews[0].backgroundColor = self.activeBackgroundColor
                element.subviews[0].layer.borderWidth = self.activeBorderWidth
                element.subviews[0].layer.borderColor = self.activeBorderColor.cgColor
            } else {
                element.subviews[0].backgroundColor = self.defaultBackgroundColor
                element.subviews[0].layer.borderWidth = self.defaultBorderWidth
                element.subviews[0].layer.borderColor = self.defaultBorderColor.cgColor
            }
            self.stackView.addArrangedSubview(element)
        }
    }
    
    private func createIndicatorView() -> UIView {
        let indicatorView = UIView()
        indicatorView.backgroundColor = .clear
        
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius = 12
        indicatorView.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 24),
            circleView.heightAnchor.constraint(equalToConstant: 24)
        ])
        return indicatorView
    }
}

