//
//  QrParentViewController.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import UIKit

class QrParentViewController : UIViewController{
    @IBOutlet weak var myQrView: UIView!
    @IBOutlet weak var reservationView: UIView!
    
    private var segmentControl : UISegmentedControl!
    private var qrReserveController:QrReservationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHide(show: myQrView, hide: reservationView)
        addSegments()
        addSubmitButton()
    }
    
    private func addSubmitButton(){
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "round_send_black_24pt"), style: .plain, target: self, action: #selector(editTap))
        button.tintColor = ColorPalette.shared.accentColor
        navigationItem.rightBarButtonItem = button
        button.isEnabled=false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des=segue.destination as? QrReservationViewController{
            qrReserveController=des
        }
    }
    @objc private func editTap(){
        qrReserveController?.reserve()
    }
    
    private func addSegments(){
        let items=[S.myQr.localized(),S.instantReservation.localized()]
        segmentControl=UISegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = ColorPalette.shared.accentColor
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segmentControl.selectedSegmentIndex=0
        segmentControl.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        segmentControl.sizeToFit()
        navigationItem.titleView=segmentControl
    }
    
    @objc private func onSegmentChange(){
        let index=segmentControl.selectedSegmentIndex
        if index==0{
            navigationItem.rightBarButtonItem?.isEnabled=false
            showHide(show: myQrView, hide: reservationView)
        }else{
            navigationItem.rightBarButtonItem?.isEnabled=true
            showHide(show: reservationView, hide: myQrView)
        }
    }
    
    private func showHide(show:UIView,hide:UIView){
        show.isHidden=false
        hide.isHidden=true
    }
    
}
