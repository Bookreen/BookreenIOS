import UIKit

class ReservationHeader: UITableViewHeaderFooterView {

    private var _dateAsString: String?
    
    var dateAsString: String? {
        get {
            return self._dateAsString
        }
        set(value) {
            self._dateAsString = value
            guard let dateAsString = self._dateAsString else {
                return
            }
            self.labelTitle.text = dateAsString
        }
    }

    fileprivate lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureContents() {
        self.contentView.backgroundColor = UIColor.secondarySystemBackground
        self.contentView.addSubview(self.labelTitle)
        NSLayoutConstraint.activate([
            self.labelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
            constant: 16),
            self.labelTitle.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: 16),
            self.labelTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}

