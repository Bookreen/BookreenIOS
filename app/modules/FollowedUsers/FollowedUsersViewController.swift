import Foundation
import UIKit

final class FollowedUsersViewController: AppViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewSearchIconView: UIView!
    @IBOutlet weak var textFieldSearch: InsetTextField!
    
    var viewModel: FollowedUsersViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchbar()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.textFieldSearch.delegate = self
        self.viewModel.loadFollowedUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        self.textFieldSearch.delegate = nil
    }
    
    private func configureSearchbar() {
        self.viewSearch.layer.cornerRadius = 16
        
        self.viewSearchIconView.layer.cornerRadius = self.viewSearchIconView.frame.width / 2
        self.viewSearchIconView.backgroundColor = ColorPalette.shared.accentColor
        
        self.textFieldSearch.placeholder = "search".localized()
        self.textFieldSearch.addTarget(self, action: #selector(onSearchHandler), for: .editingChanged)
    }
    
    @objc func onSearchHandler() {
        let searchValue = self.textFieldSearch.text ?? ""
        self.viewModel.search(searchValue)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 72)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 72)
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.isPagingEnabled = false
        
        let nib = UINib(nibName: UserCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: UserCollectionViewCell.reuseIdentifier)
    }
}

extension FollowedUsersViewController: FollowedUsersViewModelDelegate {
    func handleOutput(_ output: FollowedUsersViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .LoadedFollowedUserList:
                self.collectionView.reloadData()
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            }
        }
    }
}

extension FollowedUsersViewController: UserCollectionViewCellDelegate {
    func userCollectionViewCell(_ view: UserCollectionViewCell, follow: EmployeeModel) {
    }
    
    func userCollectionViewCell(_ view: UserCollectionViewCell, unfollow: EmployeeModel) {
        self.viewModel.unfollow(user: unfollow)
    }
}

extension FollowedUsersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        let row = indexPath.row
        cell.delegate = self
        cell.isFavorite = true
        cell.employee = self.viewModel.userList[row]
        return cell
    }
}

extension FollowedUsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
