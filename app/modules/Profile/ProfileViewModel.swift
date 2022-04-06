import Foundation
import UIKit

enum ProfileViewOutput {
    case showLoading(Bool)
    case successLogout
    case successSaveProfilePhoto
    case failureSaveProfilePhoto
    case handleError(Error)
}

protocol ProfileViewModelDelegate: AnyObject {
    func handleOutput(_ output: ProfileViewOutput)
}

protocol ProfileViewModelProtocol: AnyObject {
    var profilePhoto: String { get set }
    var displayName: String { get set }
    var email: String { get set }
    var delegate: ProfileViewModelDelegate? { get set }
    var selectedImage: UIImage? { get set }
    func logout()
    func saveProfilePhoto()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    var displayName: String {
        get {
            return SessionManager.shared.displayName
        }
        set {
           print(newValue)
        }
    }
    
    var email: String {
        get {
            return SessionManager.shared.email
        }
        set {
           print(newValue)
        }
    }
    
    var profilePhoto: String {
        get {
            return SessionManager.shared.profilePhoto
        }
        set {
            print(newValue)
        }
    }

    var delegate: ProfileViewModelDelegate?
    var selectedImage: UIImage?
    
    private let bookreenService: BookreenService
    private let authService: AuthService
    
    init(bookreenService: BookreenService, authService: AuthService) {
        self.bookreenService = bookreenService
        self.authService = authService
    }
    
    func saveProfilePhoto() {
        if let image = self.selectedImage {
            let baseEncodedImage = image.jpegData(compressionQuality: 0.25)?.base64EncodedString() ?? ""
            if baseEncodedImage.isEmpty {
                self.delegate?.handleOutput(.failureSaveProfilePhoto)
                return
            }
            self.delegate?.handleOutput(.showLoading(true))
            self.bookreenService.saveProfilePhoto(baseEncodedImage: baseEncodedImage) { result in
                self.delegate?.handleOutput(.showLoading(false))
                switch result {
                case .success(_, let output):
                    if output.status {
                        self.delegate?.handleOutput(.successSaveProfilePhoto)
                    } else {
                        self.delegate?.handleOutput(.failureSaveProfilePhoto)
                    }
                case .failure(_):
                    self.delegate?.handleOutput(.failureSaveProfilePhoto)
                }
            }
            
        }
    }
    
    func logout() {
        self.delegate?.handleOutput(.showLoading(true))
        self.authService.logout { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, _):
                self.delegate?.handleOutput(.successLogout)
            case .failure(_):
                self.delegate?.handleOutput(.successLogout)
            }
        }
    }
}
