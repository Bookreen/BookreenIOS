import Foundation
import UIKit
import WebKit
import Alamofire

final class PreviewFloorViewController: AppViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewUsers: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelScreenTitle.textColor = ColorPalette.shared.colorGrey900
        self.labelScreenTitle.font = .systemFont(ofSize: 16)
        self.labelScreenTitle.text = "pleaseSelectFloor".localized()
        self.viewHome.backgroundColor = ColorPalette.shared.accentColor
        self.viewHome.layer.cornerRadius = self.viewHome.frame.width / 2
        
        self.viewUsers.backgroundColor = ColorPalette.shared.accentColor
        self.viewUsers.layer.cornerRadius = self.viewHome.frame.width / 2
        
        let floorId = SessionManager.shared.floorId
        if !floorId.isEmpty {
            let title = "\(SessionManager.shared.campusName)/\(SessionManager.shared.buildingName)/\(SessionManager.shared.floorName)"
            self.loadUrl(title: title, floorId: floorId)
        } else {
            let title = ""
            self.loadUrl(title: title, floorId: floorId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func pressedButtonUser(_ sender: UIButton) {
        let viewController = SearchFriendBuilder.make { result in
            if let floorId = result.floorId {
                let roomId = result.spaceId ?? ""
                let title = "\(result.campusName ?? "")/\(result.buildingName ?? "")/\(result.floorName ?? "")"
                self.loadUrl(title: title, floorId: floorId, roomId: roomId)
            }
            
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedButtonHome(_ sender: UIButton) {
        let viewController = SelectFloorBuilder.makeBottomSheets { result in
            switch result {
            case .dismiss:
                print("dismiss")
            case .selectedFloor(let result):
                let title = "\(result.campusName)/\(result.buildingName)/\(result.floorName)"
                self.loadUrl(title: title, floorId: result.floorId)
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func loadUrl(title: String, floorId: String, roomId: String = "") {
        self.labelScreenTitle.text = title
        let date = Date()
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let yearString = yearFormatter.string(from: date)
        let monthString = monthFormatter.string(from: date)
        let dayString = dayFormatter.string(from: date)
        
        let requestTime = "\(yearString)-\(monthString)-\(dayString)"
        let interval = 720
        let isMobile = 1
        
        if let oldCookies = AF.session.configuration.httpCookieStorage?.cookies {
            for oldCookie in oldCookies {
                self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(oldCookie, completionHandler: nil)
            }
        }
        
        var urlAsString = ""
        if roomId.isEmpty {
            urlAsString = "https://space.bookreen.com/backend/plugins/mapplic/main/2apartment.php?floorId=\(floorId)&requestTime=\(requestTime)&interval=\(interval)&isMobile=\(isMobile)"
        } else {
            urlAsString = "https://space.bookreen.com/backend/plugins/mapplic/main/2apartment.php?floorId=\(floorId)&roomId=\(roomId)&requestTime=\(requestTime)&interval=\(interval)&isMobile=\(isMobile)"
        }
        
        if let url = URL(string: urlAsString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
