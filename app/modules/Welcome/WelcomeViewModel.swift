import Foundation
import UIKit

enum WelcomeViewOutput {
    case showLoading(Bool)
    case successSaveMyOffice
    case failureSaveMyOffice
    case successSaveProfilePhoto
    case failureSaveProfilePhoto
    case handleError(Error)
}

protocol WelcomeViewModelProtocol: AnyObject {
    var displayName: String { get set }
    var delegate: WelcomeViewModelDelegate? { get set }
    var selectedCampus: CampusModel? { get set }
    var selectedBuilding: BuildingModel? { get set }
    var selectedFloor: FloorModel? { get set }
    var selectedImage: UIImage? { get set }
    func saveMyOffice()
    func saveProfilePhoto()
}

protocol WelcomeViewModelDelegate: AnyObject {
    func handleOutput(_ output: WelcomeViewOutput)
}

final class WelcomeViewModel: WelcomeViewModelProtocol {
       
    var displayName: String {
        get {
            return SessionManager.shared.name
        }
        set {
           print(newValue)
        }
    }
    
    var selectedImage: UIImage? = nil
    var selectedCampus: CampusModel?
    var selectedFloor: FloorModel?
    var selectedBuilding: BuildingModel?
    
    
    private let bookreenService: BookreenServiceProtocol
    var delegate: WelcomeViewModelDelegate?
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
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
            
        } else {
            self.delegate?.handleOutput(.failureSaveProfilePhoto)
        }
    }
    
    func saveMyOffice() {
        let campusId = self.selectedCampus?.id ?? ""
        let campusName = self.selectedCampus?.name ?? ""
        let buildingId = self.selectedBuilding?.id ?? ""
        let buildingName = self.selectedBuilding?.name ?? ""
        let floorId = self.selectedFloor?.id ?? ""
        let floorName = self.selectedFloor?.name ?? ""
        
        if !campusId.isEmpty && !buildingId.isEmpty && !floorId.isEmpty {
            self.delegate?.handleOutput(.showLoading(true))
            let input = SaveMyOfficeInput(campusId: campusId, buildingId: buildingId, floorId: floorId)
            self.bookreenService.saveMyOffice(input: input) { result in
                self.delegate?.handleOutput(.showLoading(false))
                switch result {
                case .success(_, let output):
                    if output.status {
                        SessionManager.shared.campusId = campusId
                        SessionManager.shared.campusName = campusName
                        SessionManager.shared.buildingId = buildingId
                        SessionManager.shared.buildingName = buildingName
                        SessionManager.shared.floorId = floorId
                        SessionManager.shared.floorName = floorName
                        self.delegate?.handleOutput(.successSaveMyOffice)
                    } else {
                        self.delegate?.handleOutput(.failureSaveMyOffice)
                    }
                    self.saveProfilePhoto()
                case .failure(_):
                    self.delegate?.handleOutput(.failureSaveMyOffice)
                    self.saveProfilePhoto()
                }
            }
        } else {
            self.saveProfilePhoto()
        }
    }
}
