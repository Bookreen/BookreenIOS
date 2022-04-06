import Foundation
import UIKit

final class ProfileViewController: AppViewController {
    
    private let buttonDisableBackgroundColor = ColorPalette.shared.accentColor.withAlphaComponent(0.5)
    private let buttonBackgroundColor = ColorPalette.shared.accentColor
    private let buttonTitleColor = ColorPalette.shared.colorWhite
    private let buttonCornerRadius: CGFloat = 8
    private let buttonFont: UIFont = .systemFont(ofSize: 14)
    private let imageViewProfileBorderWidth: CGFloat = 2
    private let imageViewProfileBorderColor = ColorPalette.shared.accentColor
    private let imageViewTintColor = ColorPalette.shared.colorGrey500
    private let textColor = ColorPalette.shared.colorBlack
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonMyOffice: UIButton!
    @IBOutlet weak var buttonMyContacts: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var buttonLegal: UIButton!
    @IBOutlet weak var buttonContactUs: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var imageViewEmail: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewNameSurname: UIImageView!
    @IBOutlet weak var labelNameSurname: UILabel!
    @IBOutlet weak var buttonChangeProfileImage: UIButton!
    private let placeHolderImage = UIImage(named: "placeholder_person")

    var viewModel: ProfileViewModelProtocol!
    var picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        
        self.imageViewProfile.contentMode = .scaleToFill
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.width / 2
        self.imageViewProfile.layer.borderWidth = self.imageViewProfileBorderWidth
        self.imageViewProfile.layer.borderColor = self.imageViewTintColor.cgColor
        self.imageViewProfile.tintColor = self.imageViewTintColor
        
        self.imageViewEmail.tintColor = self.imageViewTintColor
        
        self.imageViewNameSurname.tintColor = self.imageViewTintColor
        
        self.buttonChangeProfileImage.backgroundColor = self.buttonBackgroundColor
        self.buttonChangeProfileImage.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonChangeProfileImage.titleLabel?.font = buttonFont
        self.buttonChangeProfileImage.setTitle("edit".localized(), for: .normal)
        self.buttonChangeProfileImage.layer.cornerRadius = buttonCornerRadius
        
        self.buttonMyOffice.backgroundColor = self.buttonBackgroundColor
        self.buttonMyOffice.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonMyOffice.titleLabel?.font = buttonFont
        self.buttonMyOffice.setTitle("myOffice".localized(), for: .normal)
        self.buttonMyOffice.layer.cornerRadius = buttonCornerRadius
        
        self.buttonMyContacts.backgroundColor = self.buttonBackgroundColor
        self.buttonMyContacts.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonMyContacts.titleLabel?.font = buttonFont
        self.buttonMyContacts.setTitle("myContacts".localized(), for: .normal)
        self.buttonMyContacts.layer.cornerRadius = buttonCornerRadius
        self.buttonMyContacts.isUserInteractionEnabled = true
        
        self.buttonNotification.backgroundColor = self.buttonDisableBackgroundColor
        self.buttonNotification.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonNotification.titleLabel?.font = buttonFont
        self.buttonNotification.setTitle("notifications".localized(), for: .normal)
        self.buttonNotification.layer.cornerRadius = buttonCornerRadius
        self.buttonNotification.isUserInteractionEnabled = false
        
        self.buttonLegal.backgroundColor = self.buttonDisableBackgroundColor
        self.buttonLegal.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonLegal.titleLabel?.font = buttonFont
        self.buttonLegal.setTitle("legal".localized(), for: .normal)
        self.buttonLegal.layer.cornerRadius = buttonCornerRadius
        self.buttonLegal.isUserInteractionEnabled = false

        self.buttonContactUs.backgroundColor = self.buttonBackgroundColor
        self.buttonContactUs.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonContactUs.titleLabel?.font = buttonFont
        self.buttonContactUs.setTitle("contactUs".localized(), for: .normal)
        self.buttonContactUs.layer.cornerRadius = buttonCornerRadius
        
        self.buttonLogout.backgroundColor = self.buttonBackgroundColor
        self.buttonLogout.setTitleColor(self.buttonTitleColor, for: .normal)
        self.buttonLogout.titleLabel?.font = buttonFont
        self.buttonLogout.setTitle("logout".localized(), for: .normal)
        self.buttonLogout.layer.cornerRadius = buttonCornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.viewModel.delegate = nil
    }
    
    @IBAction func pressedButtonChangeProfileImage(_ sender: UIButton) {
        self.openGallery()
    }
    
    @IBAction func pressedButtonMyOffice(_ sender: UIButton) {
        let viewController = MyOfficeViewBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedButtonMyContacts(_ sender: UIButton) {
        let viewController = MyContactsBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedButtonNotifications(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedButtonLegal(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedButtonContactUs(_ sender: UIButton) {
        let viewController = ContactUsBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedButtonLogout(_ sender: UIButton) {
        self.viewModel.logout()
    }
    
    private func updateUI() {
        if let image = self.viewModel.selectedImage {
            self.imageViewProfile.image = image
        } else {
            let profilePhoto = self.viewModel.profilePhoto
            if profilePhoto.isEmpty {
                self.imageViewProfile.image = placeHolderImage
            } else {
                let newImageData = Data(base64Encoded: profilePhoto)
                if let newImageData = newImageData {
                    self.imageViewProfile.image = UIImage(data: newImageData)
                } else {
                    self.imageViewProfile.image = placeHolderImage
                }
            }
        }
        self.labelNameSurname.text = self.viewModel.displayName
        self.labelEmail.text = self.viewModel.email
    }
    
    private func openGallery() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            picker.sourceType = .photoLibrary
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
        }
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: ProfileViewModelDelegate {
    func handleOutput(_ output: ProfileViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .successLogout:
                SessionManager.shared.logout()
                self.restartApp()
            case .successSaveProfilePhoto:
                print("successSaveProfilePhoto")
            case .failureSaveProfilePhoto:
                print("failureSaveProfilePhoto")
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        self.imageViewProfile.image = image
        self.viewModel.selectedImage = image
        self.viewModel.saveProfilePhoto()
    }
}
