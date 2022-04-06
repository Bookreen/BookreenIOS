//
//  MyCodeViewController.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import UIKit
import SDWebImage
import RxSwift

class MyCodeViewController : UIViewController{
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private let bag=DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text=SessionManager.shared.email
        nameLabel.text=SessionManager.shared.displayName
        profileImageView.layer.cornerRadius=40
        profileImageView.image = SessionManager.shared.profilePhoto
            .base64ToImage(placeholder:  UIImage(named: "placeholder_person")!)
        if let barcode=SessionManager.shared.email.barcoded(){
            qrImageView.image=barcode
        }
    }
}
