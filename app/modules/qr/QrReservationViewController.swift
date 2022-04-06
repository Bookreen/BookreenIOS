//
//  QrReservationViewController.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import UIKit
import RxSwift
import SDWebImage

class QrReservationViewController : UIViewController{
    
    @IBOutlet weak var tapScanLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var previousBookingLabel: UILabel!
    @IBOutlet weak var minutesSegments: UISegmentedControl!
    @IBOutlet weak var reserveNowLabel: UILabel!
    @IBOutlet weak var deskStatusLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var previousTableVIew: UITableView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var tapScanStack: UIStackView!
    
    
    var info:LocationEvents?
    var previousBookings=[LocationEvent]()
    private var allTap:UITapGestureRecognizer!
    
    let bag=DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allTap=UITapGestureRecognizer(target: self, action: #selector(onRootTap))
        view.isUserInteractionEnabled=true
        view.addGestureRecognizer(allTap)
        previousTableVIew.isHidden=true
        contentStackView.isHidden=true
        imageContainerView.layer.cornerRadius=4.0
        imageContainerView.layer.masksToBounds=true
        previousBookingLabel.isHidden=true
        minutesSegments.setTitle(S.restOfDay.localized(), forSegmentAt: 4)
        reserveNowLabel.text=S.reserveNow.localized()
        tapScanLabel.text=S.tapToScan.localized()
        previousTableVIew.delegate=self
        previousTableVIew.dataSource=self
    }
    
    
    @objc private func onRootTap(){
        let vC=QrCodeScannerBuilder.make {
            self.loadLocation($0.code)
        }
        self.present(vC, animated: true, completion: nil)
//        let desk="706870467031702469957066706870247062702070697025694793f6c"
//        loadLocation(desk)
    }
    
    private func loadLocation(_ locationId:String){
        tapScanStack.isHidden=true
        view.removeGestureRecognizer(allTap)
        NotificationCenter.default.post(name: .showLoadingView, object: self)
        QrBookingService.instance.locationEvents(locationId)
            .subscribe {
                NotificationCenter.default.post(name: .dismissLoadingView, object: self)
                self.setup($0)
            } onFailure: { error in
                NotificationCenter.default.post(name: .dismissLoadingView, object: self)
                DialogUtil.showOk(self, error.localizedDescription)
            }.disposed(by: bag)
        
    }
    
    private func setup(_ result:LocationEvents){
        if result.location.status == "0"{
            tapScanStack.isHidden=false
            view.addGestureRecognizer(allTap)
            DialogUtil.showOk(self, S.notAvailableBookingMessage)
            return
        }
        info=result
        contentStackView.isHidden=false
        let placeholder = UIImage(named: "placeholder_meeting_room")
        if let path=result.location.mediaFilePath{
            roomImageView.sd_setImage(with: try? "\(baseUrl)/\(path)".asURL(),placeholderImage:placeholder)
        }else{
            roomImageView.image=placeholder
        }
        locationLabel.text=result.location.locationDescription()
        placeNameLabel.text=result.location.name
        if let events=result.events,events.count>0{
            self.previousBookings=events
            showTable()
            deskStatusLabel.isHidden=true
            checkReservationTimes()
        }else{
            previousBookingLabel.isHidden=true
            previousTableVIew.isHidden=true
            deskStatusLabel.text=S.allDayFree.localized().replacingOccurrences(of: "%s", with: result.location.name ?? "")
        }
        
    }
    
    private func showTable(){
        previousBookingLabel.isHidden=false
        previousTableVIew.isHidden=false
        previousTableVIew.reloadData()
    }
}
