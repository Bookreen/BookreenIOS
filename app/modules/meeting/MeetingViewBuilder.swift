//
//  MeetingViewBuilder.swift
//  Bookreen
//
//  Created by bullhead on 12/2/21.
//

import UIKit
import Then

final class MeetingViewBuilder{
    
    private init () {}
    
    static func build() -> MeetingViewController {
        let storyboard = UIStoryboard(name: "Meeting", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MeetingViewController") as! MeetingViewController
        return viewController
    }
    
    static func build(_ booking:BookingModel) -> MeetingViewController {
        let storyboard = UIStoryboard(name: "Meeting", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MeetingViewController") as! MeetingViewController
        let formatter=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd"
        }
        let timeFormatter=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd HH:mm"
        }
        if let ds=booking.planDate,let date=formatter.date(from: ds){
            viewController.selectedDate=date
            var allDayStart=false
            if let st=booking.startTime,let s=timeFormatter.date(from: "\(ds) \(st)"){
                viewController.startTime=s
                allDayStart=st==SessionManager.shared.workStartTime
            }
            if let et=booking.endTime,let e=timeFormatter.date(from: "\(ds) \(et)"){
                viewController.endTime=e
                viewController.allDay=allDayStart && et==SessionManager.shared.workEndTime
            }
        }
        if let c=booking.color{
            viewController.selectedColor=c
        }
        if let p=booking.participants{
            viewController.participants.append(contentsOf: p)
        }
        viewController.initialValues=(booking.subject,booking.description,booking.virtualLink)
        viewController.id=booking.id
        return viewController
    }
}
