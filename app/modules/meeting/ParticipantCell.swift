//
//  ParticipantCell.swift
//  Bookreen
//
//  Created by bullhead on 12/2/21.
//

import UIKit

class ParticipantCell : UICollectionViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    static func create()->UINib{
        return UINib(nibName: "ParticipantCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius=20
        contentView.isUserInteractionEnabled=true
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    var listener:((ParticipantModel)->Void)?
    private var item:ParticipantModel?
    private let placeHolderImage = UIImage(named: "placeholder_person")

    func bind(_ participant:ParticipantModel){
        self.item=participant
        nameLabel.text=participant.fullname
        if participant.id=="-1"{
            self.imageView.image=UIImage(systemName: "person.crop.circle.fill.badge.plus")
            self.imageView.tintColor = UIColor.systemGray
        }else{
            setImage(participant.profilePhoto ?? "")
        }
    }
    
    private func setImage(_ profilePhoto:String){
        if let _data = Data(base64Encoded: profilePhoto),let profilePhotoImage = UIImage(data: _data) {
                self.imageView.image = profilePhotoImage
                self.imageView.tintColor = .clear
        } else {
            self.imageView.tintColor = ColorPalette.shared.colorBlack
            self.imageView.image = placeHolderImage
        }
    }
    
    @objc private func onTap(){
        if let i=item{
            listener?.self(i)
        }
    }
    
}
