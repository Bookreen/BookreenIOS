import UIKit
import WebKit

class AppBrowserViewController: AppViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imageButtonView: ImageButtonView!
    
    var screenTitle: String = ""
    var urlAsString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorPalette.shared.colorWhite
        self.labelScreenTitle.font = .boldSystemFont(ofSize: 16)
        self.labelScreenTitle.textColor = ColorPalette.shared.colorWhite
        self.labelScreenTitle.text = screenTitle
        
        guard let url = URL(string: urlAsString) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageButtonView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageButtonView.delegate = nil
    }
    
    
    @IBAction func pressedButtonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AppBrowserViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}
