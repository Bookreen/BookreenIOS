import Foundation
import UIKit

final class WelcomeUploadProfilePhotoViewController: SlideViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var buttonChooseProfilePhoto: UIButton!
    
    var picker = UIImagePickerController()
    var selectedImage: UIImage?
    private let placeHolderImage = UIImage(named: "placeholder_person")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.view.backgroundColor = .clear
        self.labelTitle.textAlignment = .center
        self.labelTitle.text = "selectProfilePhoto".localized()
        self.labelTitle.font = .boldSystemFont(ofSize: 16)
        self.labelTitle.textColor = ColorPalette.shared.colorBlack.withAlphaComponent(0.6)
        
        self.imageViewProfilePhoto.contentMode = .scaleToFill
        self.imageViewProfilePhoto.tintColor = ColorPalette.shared.colorGrey700
        self.imageViewProfilePhoto.layer.borderWidth = 2
        self.imageViewProfilePhoto.layer.borderColor = ColorPalette.shared.accentColor.cgColor
        self.imageViewProfilePhoto.layer.cornerRadius = self.imageViewProfilePhoto.frame.width / 2
        
        self.buttonChooseProfilePhoto.backgroundColor = ColorPalette.shared.accentColor
        self.buttonChooseProfilePhoto.layer.cornerRadius = 4
        self.buttonChooseProfilePhoto.titleLabel?.font = .systemFont(ofSize: 14)
        self.buttonChooseProfilePhoto.setTitleColor(ColorPalette.shared.colorWhite, for: .normal)
        self.buttonChooseProfilePhoto.setTitle("choose".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    @IBAction func pressedButtonChoose(_ sender: UIButton) {
        self.openGallery()
    }
    
    private func updateUI() {
        if let image = self.selectedImage {
            self.imageViewProfilePhoto.image = image
        } else {
            let profilePhoto = SessionManager.shared.profilePhoto
            if profilePhoto.isEmpty {
                self.imageViewProfilePhoto.image = placeHolderImage
            } else {
                let newImageData = Data(base64Encoded: profilePhoto)
                if let newImageData = newImageData {
                    self.imageViewProfilePhoto.image = UIImage(data: newImageData)
                } else {
                    self.imageViewProfilePhoto.image = placeHolderImage
                }
            }
        }
    }
}


extension WelcomeUploadProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        self.imageViewProfilePhoto.image = image
        self.delegate?.onChangeProfilePhoto(image: image)
    }
}
