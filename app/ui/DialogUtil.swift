//
//  DialogUtil.swift
//  Bookreen
//
//  Created by bullhead on 12/3/21.
//

import UIKit
class DialogUtil {
    static func showOk(_ controller:UIViewController, _ message:String,done:(()->())?=nil){
        let alert=UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.ok.localized(), style: .default, handler: {_ in
            if let don=done{
                don()
            }
        }))
        alert.view.tintColor=ColorPalette.shared.accentColor
        controller.present(alert, animated: true, completion: nil)
    }
}
