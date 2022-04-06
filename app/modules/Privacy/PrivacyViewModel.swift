import Foundation
enum PrivacyViewOutput {
    case navigateHome
    case navigateWelcome
    case showLoading(Bool)
}

protocol PrivacyViewModelDelegate: AnyObject {
    func handleOutput(_ output: PrivacyViewOutput)
}


protocol PrivacyViewModelProtocol {
    var delegate: PrivacyViewModelDelegate? { get set }
    var user:UserModel {get set}
    func acceptPrivacyPolicy()
}

final class PrivacyViewModel: PrivacyViewModelProtocol {
    
    var delegate: PrivacyViewModelDelegate?
    private let bookreenService: BookreenServiceProtocol
    var user: UserModel
    init(user:UserModel,bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.user=user
    }
    
    private func onDone(){
        self.delegate?.handleOutput(.showLoading(false))
        if !user.isExistsMyOffice(){
            self.delegate?.handleOutput(.navigateWelcome)
        }else{
            self.delegate?.handleOutput(.navigateHome)
        }
    }
    
    func acceptPrivacyPolicy() {
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.acceptPrivacyPolicy { result in
            switch result {
            case .success(_, _):
                self.onDone()
            case .failure(_):
                self.onDone()
            }
        }
    }
}
