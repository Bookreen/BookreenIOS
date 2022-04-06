import Foundation
import UIKit
import Lottie

final class SearchFriendViewController: AppViewController {
    
    @IBOutlet weak var labelSearch: UILabel!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var imageViewSearchBar: UIImageView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var tableViewFriends: UITableView!
    @IBOutlet weak var tableViewDesks: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var viewLottieAnimation: AnimationView!
    
    
    var callback: ((BookingModel) -> Void)?
    var viewModel: SearchFriendViewModelProtocol!
    var justSelect=false
    var selectCallback:((ParticipantModel)->Void)?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Set animation content mode
        self.viewLottieAnimation.contentMode = .scaleAspectFit
        // 2. Set animation loop mode
        self.viewLottieAnimation.loopMode = .loop
        // 3. Adjust animation speed
        self.viewLottieAnimation.animationSpeed = 0.5
        // 4. Play animation
        self.viewLottieAnimation.play()
        
        self.labelEmpty.font = .systemFont(ofSize: 14)
        self.labelEmpty.text = "noFoundBooking".localized()
        
        
        self.viewSearchBar.layer.cornerRadius = 10.0
        
        self.labelSearch.font = .systemFont(ofSize: 14)
        self.labelSearch.text = "friendName".localized()
        self.labelSearch.textColor = ColorPalette.shared.accentColor
        
        self.textFieldSearch.placeholder = "search".localized()
        
        self.textFieldSearch.addTarget(self, action: #selector(changeTextFieldSearch), for: .editingChanged)
        
        self.configureTableView(self.tableViewDesks)
        self.configureTableView(self.tableViewFriends)
        
        self.viewEmpty.alpha = 0.0
        self.tableViewDesks.tag = 1
        self.tableViewFriends.tag = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.tableViewFriends.delegate = self
        self.tableViewFriends.dataSource = self
        self.tableViewDesks.delegate = self
        self.tableViewDesks.dataSource = self
        self.textFieldSearch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        self.tableViewFriends.delegate = nil
        self.tableViewFriends.dataSource = nil
        self.tableViewDesks.delegate = nil
        self.tableViewDesks.dataSource = nil
        self.textFieldSearch.delegate = nil
    }
    
    private func configureTableView(_ tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    private func checkHasExistsAvailableDesk() {
        if self.viewModel.bookingList.isEmpty {
            self.tableViewDesks.alpha = 0
            self.viewEmpty.alpha = 1
        } else {
            self.tableViewDesks.alpha = 1
            self.viewEmpty.alpha = 0
        }
    }
    
    @objc func changeTextFieldSearch() {
        self.viewEmpty.alpha = 0
        let searchText = self.textFieldSearch.text ?? ""
        if searchText.count > 2 {
            self.viewModel.searchFriend(searchText: searchText)
        } else {
            self.viewModel.clearFriend()
        }
        self.tableViewDesks.alpha = 0
        self.tableViewDesks.isUserInteractionEnabled = false
        self.tableViewFriends.alpha = 1
        self.tableViewFriends.isUserInteractionEnabled = true
    }
    
}

extension SearchFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return self.viewModel.bookingList.count
        } else if tableView.tag == 2 {
            return self.viewModel.participantList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let index = indexPath.row
            let booking = self.viewModel.bookingList[index]
            self.navigationController?.popViewController(animated: true)
            self.callback?(booking)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let index = indexPath.row
            let cell = Bundle.main.loadNibNamed("DeskTableViewCell", owner: self, options:nil)?.first as! DeskTableViewCell
            cell.booking = viewModel.bookingList[index]
            cell.selectionStyle = .none
            return cell
        } else if tableView.tag == 2 {
            let index = indexPath.row
            let cell = Bundle.main.loadNibNamed("ParticipantTableViewCell", owner: self, options:nil)?.first as! ParticipantTableViewCell
            cell.delegate = self
            cell.participant = self.viewModel.participantList[index]
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension SearchFriendViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchFriendViewController: ParticipantTableViewCellDelegate {
    func pressedParticipantTableViewCell(_ sender: ParticipantTableViewCell) {
        if justSelect{
            selectCallback?.self(sender.participant!)
            dismiss(animated: true)
        }else{
            let email = sender.participant?.email ?? ""
            if email.count > 0 {
                self.viewModel.searchBookingByEmail(email: email)
                self.tableViewDesks.alpha = 1
                self.tableViewDesks.isUserInteractionEnabled = true
                self.tableViewFriends.alpha = 0
                self.tableViewFriends.isUserInteractionEnabled = false
            } else {
                self.tableViewDesks.alpha = 0
                self.tableViewDesks.isUserInteractionEnabled = false
                self.tableViewFriends.alpha = 1
                self.tableViewFriends.isUserInteractionEnabled = true
            }
            
        }
    }
}

extension SearchFriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


extension SearchFriendViewController: SearchFriendViewModelDelegate {
    func handleOutput(_ output: SearchFriendViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .successFetchedParticipantList:
                self.tableViewFriends.reloadData()
            case .successFetchedBookingList:
                self.tableViewDesks.reloadData()
                self.checkHasExistsAvailableDesk()
            case .handleError(let error):
                self.handleError(error)
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
