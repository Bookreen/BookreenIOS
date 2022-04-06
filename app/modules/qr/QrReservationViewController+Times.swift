//
//  QrReservationViewController+Times.swift
//  Bookreen
//
//  Created by bullhead on 12/10/21.
//

import Foundation
extension QrReservationViewController{
    func checkReservationTimes(){
        let now=isReserved(at: Date(),now: true)
        if now{
            minutesSegments.isEnabled=false
        }else{
            minutesSegments.setEnabled(false, forSegmentAt: 4)
            let date=Date()
            let c=Calendar.current
            [30,45,60,120].enumerated()
                .forEach {
                    let reserved=self.isReserved(at: c.date(byAdding: .minute, value: $0.element, to: date)!)
                    minutesSegments.setEnabled(!reserved, forSegmentAt: $0.offset)
                }
            minutesSegments.isEnabled = minutesSegments.isEnabledForSegment(at: 0)
        }
    }
    
    
    private func isReserved(at date:Date, now:Bool=false)->Bool{
        if previousBookings.isEmpty{
            return false
        }
        let formatter=DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm"
        for booking in previousBookings{
            let start=formatter.date(from: "\(booking.date) \(booking.fixedStart)")
            let end=formatter.date(from: "\(booking.date) \(booking.fixedEnd)")
            if let s=start,let e=end{
                if s <= date{
                    if now{
                        return e >= date
                    }
                    return true
                }
            }
        }
        
        return false
    }
}
