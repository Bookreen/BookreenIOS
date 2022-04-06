import Foundation

enum FollowedUsersViewOutput {
    case LoadedFollowedUserList
    case showLoading(Bool)
}

protocol FollowedUsersViewModelProtocol: AnyObject {
    var delegate: FollowedUsersViewModelDelegate? { get set }
    var userList: [EmployeeModel] { get set }
    var searchValue: String { get set }
    func loadFollowedUsers()
    func unfollow(user: EmployeeModel)
    func search(_ searchValue: String)
}

protocol FollowedUsersViewModelDelegate: AnyObject {
    func handleOutput(_ output: FollowedUsersViewOutput)
}

final class FollowedUsersViewModel: FollowedUsersViewModelProtocol {
 
    var delegate: FollowedUsersViewModelDelegate?
    var searchValue: String = ""
    private var _userList: [EmployeeModel] = []
    var userList: [EmployeeModel] = [] {
        didSet {
            self.delegate?.handleOutput(.LoadedFollowedUserList)
        }
    }
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.searchValue = ""
        self.userList = []
    }
    
    func search(_ searchValue: String) {
        self.searchValue = searchValue
        if self._userList.isEmpty {
            self.userList = []
            return
        }
        
        if searchValue.isEmpty {
            self.userList = self._userList
            return
        }
        
        self.userList = self._userList.filter({ item in
            let name = item.name ?? ""
            let surname = item.surname ?? ""
            let email = item.email ?? ""
            
            let lowercasedSearchValue = searchValue.lowercased()
            
            return name.lowercased().contains(lowercasedSearchValue) ||
            surname.lowercased().contains(lowercasedSearchValue) ||
            email.lowercased().contains(lowercasedSearchValue)
        })
    }
    
    func loadFollowedUsers() {
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.getMyFriends { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self._userList = []
                self.search(self.searchValue)
            case .success(_, let data):
                self._userList = data
                self.search(self.searchValue)
            }
        }
    }
    
    func unfollow(user: EmployeeModel) {
        self.delegate?.handleOutput(.showLoading(true))
        let input = FollowUserInput(email: user.email ?? "", isFollow: false)
        self.bookreenService.followUser(input: input) { result in
            self.loadFollowedUsers()
        }
    }
}

