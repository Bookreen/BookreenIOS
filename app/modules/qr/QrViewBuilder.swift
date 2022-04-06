//
//  QrViewBuilder.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import UIKit

final class QrViewBuilder{
    private init(){}
    
    static func build()->QrParentViewController{
        let controller=UIStoryboard(name: "Qr", bundle: nil)
            .instantiateInitialViewController() as! QrParentViewController
        return controller
    }
}
