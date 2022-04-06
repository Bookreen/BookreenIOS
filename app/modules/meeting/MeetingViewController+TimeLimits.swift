//
//  MeetingViewController+TimeLimits.swift
//  Bookreen
//
//  Created by bullhead on 2/7/22.
//

import UIKit

extension MeetingViewController{
    func updateTimeLimits(){
        let formatter=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd HH:mm"
        }
        let dF=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd"
        }
        let today=dF.string(from: selectedDate)
        let ss="\(today) \(SessionManager.shared.workStartTime)"
        let ee="\(today) \(SessionManager.shared.workEndTime)"
        let s=formatter.date(from: ss) ?? selectedDate
        let e=formatter.date(from: ee) ?? selectedDate
        let min = selectedDate > s  ? selectedDate : s
        startTimePicker.minimumDate=min
        endTimePicker.minimumDate=min.advanced(by: 30*60)
        endTimePicker.maximumDate=e
        startTimePicker.maximumDate=e.advanced(by: -30*60)
    }
    
    @objc func onStartTimeChange(){
        startTime=startTimePicker.date
        if endTime <= startTime{
            endTime=startTime.advanced(by: 30*60)
        }
        toggleAllDay()
        getAutoSpace()
    }
    
    @objc func onEndTimeChange(){
        endTime=endTimePicker.date
        if endTime <= startTime{
            startTime=endTime.advanced(by: -30*60)
        }
        toggleAllDay()
        getAutoSpace()
    }
}
