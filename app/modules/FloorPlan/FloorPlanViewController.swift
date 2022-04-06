import Foundation
import UIKit
import WebKit
import Alamofire

final class FloorPlanViewController: AppViewController, WKNavigationDelegate {
    
    @IBOutlet weak var buttonChange: UIButton!
    @IBOutlet weak var webView: WKWebView!

    private var isLoadedCookies = false
    var viewModel: FloorPlanViewModelProtocol!
    var callback: ((ReservationSpaceModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonChange.layer.cornerRadius = 4
        self.buttonChange.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.buttonChange.setTitle("change".localized(), for: .normal)
        self.buttonChange.backgroundColor = ColorPalette.shared.accentColor
        self.buttonChange.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSelectedOfficeHandler(_:)), name: .didChangeSelectedOffice, object: nil)
        self.viewModel.delegate = self
        self.webView.navigationDelegate = self
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.viewModel.loadDesks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
        self.viewModel.delegate = nil
        self.webView.removeObserver(self, forKeyPath: "URL")
        self.webView.navigationDelegate = nil
    }
    
    @objc func didChangeSelectedOfficeHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let campusId = data["campusId"] ?? ""
            let campusTitle = data["campusTitle"] ?? ""
            let buildingId = data["buildingId"] ?? ""
            let buildingTitle = data["buildingTitle"] ?? ""
            let floorId = data["floorId"] ?? ""
            let floorTitle = data["floorTitle"] ?? ""
            let spaceId = data["spaceId"] ?? ""
            let spaceTitle = data["spaceTitle"] ?? ""
            
            let oldPresenter = self.viewModel.presenter
            self.viewModel.presenter = FloorPlanViewPresenter(
                planDate: oldPresenter.planDate,
                startTime: oldPresenter.startTime,
                endTime: oldPresenter.endTime,
                selectedSpace: ReservationSpaceModel(
                    spaceId: spaceId,
                    spaceName: spaceTitle,
                    campusId: campusId,
                    campusName: campusTitle,
                    buildingId: buildingId,
                    buildingName: buildingTitle,
                    floorId: floorId,
                    floorName: floorTitle
                )
            )
            self.viewModel.loadDesks()
        }
    }
    
    @IBAction func pressedButtonChange(_ sender: UIButton) {
        if let _space = self.viewModel.selectedSpace {
            let reservationSpace = ReservationSpaceModel(
                spaceId: _space.id,
                spaceName: _space.name,
                campusId: _space.campusId,
                campusName: _space.campusName,
                buildingId: _space.buildingId,
                buildingName: _space.buildingName,
                floorId: _space.floorId,
                floorName: _space.floorName
            )
            self.callback?(reservationSpace)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            self.detechLocationId()
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("memoryyyy")
    }
    private func detechLocationId() {
        self.webView.evaluateJavaScript("document.URL") { response, error in
            if let urlResponse = response as? String {
                print(urlResponse)
                let urlSplit = urlResponse.components(separatedBy: "&location=")
                print(urlSplit)
                if urlSplit.count > 1 {
                    let roomId = urlSplit[1]
                    print(roomId)
                    let findSpace = self.viewModel.findSpace(roomId)
                    if let _space = findSpace {
                        self.viewModel.selectedSpace = _space
                        if (_space.id ?? "") != (self.viewModel.presenter.selectedSpace?.spaceId ?? "") {
                            let buttonTitle = "change_desk_with_other_desk".localized()
                                .replacingOccurrences(of: "[%currentDesk%]", with: self.viewModel.presenter.selectedSpace?.spaceName ?? "")
                                .replacingOccurrences(of: "[%newDesk%]", with: _space.name ?? "")
                            self.buttonChange.setTitle(buttonTitle, for: .normal)
                        } else {
                            self.buttonChange.setTitle("change".localized(), for: .normal)
                        }
                    } else {
                        self.viewModel.selectedSpace = nil
                        self.buttonChange.setTitle("change".localized(), for: .normal)
                    }
                }
                
            }
        }
    }
    
    private func loadUrl(planDate: String, floorId: String, roomId: String) {
        let interval = 720
        let isMobile = 1
        
        if let oldCookies = AF.session.configuration.httpCookieStorage?.cookies {
            for oldCookie in oldCookies {
                self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(oldCookie, completionHandler: nil)
            }
        }
        
        let urlAsString = "https://space.bookreen.com/backend/plugins/mapplic/main/2apartment.php?floorId=\(floorId)&roomId=\(roomId)&requestTime=\(planDate)&interval=\(interval)&isMobile=\(isMobile)&spaceTypeId=\(viewModel.spaceType.rawValue)"
        print("URL -- \(urlAsString)")
        if let url = URL(string: urlAsString) {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
            }
        }
    }
}

extension FloorPlanViewController: FloorPlanViewModelDelegate {
    func handleOutput(_ output: FloorPlanViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .LoadedDesks:
                let planDate = self.viewModel.presenter.planDate
                let selectedSpace = self.viewModel.presenter.selectedSpace
                let floorId = selectedSpace?.floorId ?? ""
                let roomId = selectedSpace?.spaceId ?? ""
                self.loadUrl(planDate: planDate, floorId: floorId, roomId: roomId)
            }
        }
    }
}
