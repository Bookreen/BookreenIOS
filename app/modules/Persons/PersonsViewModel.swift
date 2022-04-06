import Foundation

enum PersonsViewOutput {
    case LoadedPersonList
    case showLoading(Bool)
}

protocol PersonsViewModelProtocol: AnyObject {
    var delegate: PersonsViewModelDelegate? { get set }
    var userList: [EmployeeModel] { get set }
    var followedUserList: [EmployeeModel] { get set }
    var searchValue: String { get set }
    func loadPersons()
    func loadFollowedUsers()
    func follow(user: EmployeeModel)
    func search(_ searchValue: String)
}

protocol PersonsViewModelDelegate: AnyObject {
    func handleOutput(_ output: PersonsViewOutput)
}

final class PersonsViewModel: PersonsViewModelProtocol {
 
    var delegate: PersonsViewModelDelegate?
    var followedUserList: [EmployeeModel]
    var searchValue: String = ""
    private var _userList: [EmployeeModel] = []
    var userList: [EmployeeModel] = [] {
        didSet {
            self.delegate?.handleOutput(.LoadedPersonList)
        }
    }
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.searchValue = ""
        self.userList = []
        self._userList = []
        self.followedUserList = []
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
        self.bookreenService.getMyFriends { result in
            switch result {
            case .failure(_):
                self.followedUserList = []
            case .success(_, let data):
                self.followedUserList = data
            }
            self.loadPersons()
        }
    }
    
    private func isFollowedUser(followedUserList: [EmployeeModel], employee: EmployeeModel) -> Bool {
        for item in followedUserList {
            if (item.id ?? "") == (employee.id ?? "") {
                return true
            }
        }
        return false
    }
    
    func loadPersons() {
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.getEmployees { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self._userList = []
                self.search(self.searchValue)
            case .success(_, let data):
                var tempUserList: [EmployeeModel] = []
                (data ?? []).forEach { item in
                    if !self.isFollowedUser(followedUserList: self.followedUserList, employee: item) {
                        tempUserList.append(item)
                    }
                }
                self._userList = tempUserList
                self.search(self.searchValue)
            }
        }
    }
    
    func follow(user: EmployeeModel) {
        let input = FollowUserInput(email: user.email ?? "", isFollow: true)
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.followUser(input: input) { result in
            switch result {
            case .failure(_):
                self.loadPersons()
            case .success(_, let response):
                if response.status {
                    self.followedUserList.append(user)
                }
                self.loadPersons()
            }
        }
    }
}
