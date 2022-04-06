import Foundation
import UIKit
import WebKit
import Alamofire

final class DepartmentViewController: AppViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonChange: UIButton!

    var viewModel: DepartmentViewModelProtocol!
    var callback: ((SpaceModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonChange.layer.cornerRadius = 4
        self.buttonChange.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.buttonChange.setTitle(S.change.localized(), for: .normal)
        buttonChange.layer.cornerRadius=10.0
        self.buttonChange.backgroundColor = ColorPalette.shared.accentColor
        self.buttonChange.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)

        
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: (self.view.frame.width - 24) / 2, height: 168)
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.isPagingEnabled = false
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let nib = UINib(nibName: SpaceHorizontalCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: SpaceHorizontalCollectionViewCell.reuseIdentifier)
    }
    
    private func loadUrl(groupLink: String) {
        if groupLink.isEmpty {
            return
        }
        
        if let oldCookies = AF.session.configuration.httpCookieStorage?.cookies {
            for oldCookie in oldCookies {
                self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(oldCookie, completionHandler: nil)
            }
        }
        
        let urlAsString = "https://space.bookreen.com\(groupLink)&isMobile=1&spaceTypeId=\(viewModel.spaceType.rawValue)"
        if let url = URL(string: urlAsString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    @IBAction func pressedButtonChange(_ sender: UIButton) {
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
                        self.navigationController?.popViewController(animated: true)
                        self.callback?(_space)
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
        
        if let url = URL(string: urlAsString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}


extension DepartmentViewController: DepartmentViewModelDelegate {
    func handleOutput(_ output: DepartmentViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .LoadedDepartment:
                let spaceGroup = self.viewModel.spaceGroup
                self.title = spaceGroup.groupName ?? "Diğer"
                self.collectionView.reloadData()
                self.loadUrl(groupLink: spaceGroup.groupLink ?? "")
            case .ReloadList:
                self.collectionView.reloadData()
            }
        }
    }
}

extension DepartmentViewController: SpaceHorizontalCollectionViewCellDelegate {
    func spaceHorizontalCollectionViewCell(_ view: SpaceHorizontalCollectionViewCell, addFavorite: SpaceModel) {
        if (addFavorite.isMyFavorite ?? "false") == "true" {
            self.viewModel.removeFavorite(space: addFavorite)
        } else {
            self.viewModel.addFavorite(space: addFavorite)
        }
    }
}

extension DepartmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let occasions = self.viewModel.spaceGroup.occasions ?? []
        let row = occasions[indexPath.row]
        self.navigationController?.popViewController(animated: true)
        self.callback?(row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.spaceGroup.occasions ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let occasions = self.viewModel.spaceGroup.occasions,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceHorizontalCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? SpaceHorizontalCollectionViewCell {
            cell.space = occasions[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}
