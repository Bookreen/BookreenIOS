//
//  QrBookingService.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import Foundation
import RxSwift

final class QrBookingService{
    static let instance=QrBookingService.init()
    private let bg=ConcurrentDispatchQueueScheduler.init(qos: .background)
    private let main=MainScheduler.instance
    private init(){
        
    }
    
    func locationEvents(_ locationId:String)->Single<LocationEvents>{
        return URLRequest(withMobile: "/getLocationWithEvents")
            .formEncoded(["LocationID":locationId])
            .perform(type: LocationEvents.self)
            .map({ event in
                var mutable=event
                mutable.events=event.events?.filter({$0.status != "9"})
                return mutable
            })
            .subscribe(on: bg)
            .observe(on: main)
    }
}
