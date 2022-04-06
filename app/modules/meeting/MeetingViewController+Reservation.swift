//
//  MeetingViewController+Reservation.swift
//  Bookreen
//
//  Created by bullhead on 12/2/21.
//

import UIKit
import RxSwift
import Alamofire
extension MeetingViewController{
    
    func setupBooking(){
        if let value=initialValues{
            subjectTextField.text=value.subject
            descriptionTextField.text=value.description
            virtualTextField.text=value.link
        }
        setupParticipants()
        updateReminder()
        updateDate()
        toggleAllDay()
        getAutoSpace()
    }
    
    func getAutoSpace(){
        BookingService.instance.findAutoSpace(start: startTime, end: endTime, isAllDay: allDay,capacity: participants.count)
            .subscribe { space in
                self.space=space
                self.updateSpace()
            } onFailure: { error in
                print("failed to get space because "+error.localizedDescription)
            }.disposed(by: bag)
    }
    
    func updateReminder(){
        let minute = reminderMinutes
        let minuteUnit = S.minuteUnit.localized()
        let reminderFormat = S.reminderFormat.localized()
        let boldText = "\(minute) \(minuteUnit)"
        let reminder = reminderFormat
            .replacingOccurrences(of: "[&reminderMinutes&]", with: "\(minute)")
            .replacingOccurrences(of: "[&minuteUnit&]", with: "\(minuteUnit)")
        
        let reminderMutableString = NSMutableAttributedString(
            string: reminder,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
        )
        
        reminderMutableString.setFont(textForAttribute: boldText, withFont: UIFont.boldSystemFont(ofSize: 14))
        reminderLabel.attributedText=reminderMutableString
    }
    
    func updateSpace(){
        roomTextField.text=space?.spaceName
    }
    
    func updateDate(){
        let formatter=DateFormatter()
        formatter.dateFormat="EEE,MMM d"
        dateTextField.text=formatter.string(from: selectedDate)
    }
    
    func toggleAllDay(){
        startTimeContainer.isUserInteractionEnabled = !allDay
        endTimeContainer.isUserInteractionEnabled = !allDay
        let alpha=allDay ? 0.5 : 1
        startTimeContainer.alpha=alpha
        endTimeContainer.alpha=alpha
        let formatter=DateFormatter()
        let df=DateFormatter()
        df.dateFormat="yyyy-MM-dd"
        let selected=df.string(from: selectedDate)
        formatter.dateFormat="yyyy-MM-dd HH:mm"
        if allDay{
            if let s=formatter.date(from: "\(selected) \(SessionManager.shared.workStartTime)"){
                startTimePicker.date=s
            }
            if let e=formatter.date(from: "\(selected) \(SessionManager.shared.workEndTime)"){
                endTimePicker.date=e
            }
        }else{
            startTimePicker.date=startTime
            endTimePicker.date=endTime
        }
    }
    
    func submit(){
        let subject = subjectTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if subject.isEmpty{
            DialogUtil.showOk(self, S.writeSubject.localized())
            return
        }
        let participants=self.participants.filter({ $0.id != "-1"})
        
        let formatter=DateFormatter()
        formatter.dateFormat="HH:mm"
        let date=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd"
        }.string(from: selectedDate)
        let start = allDay ? SessionManager.shared.workStartTime : formatter.string(from: startTime)
        let end = allDay ? SessionManager.shared.workEndTime : formatter.string(from: endTime)
        let call:Single<String>
        if let id=self.id{
            call=update(id:id,subject:subject, date: date, start: start, end: end, participants: participants)
        }else{
            call=save(subject:subject, date: date, start: start, end: end, participants: participants)
        }
        toggleProgress(true)
        call.subscribe { res in
                self.toggleProgress(false)
                DialogUtil.showOk(self, res) {
                    self.navigationController?.popViewController(animated: true)
                }
            } onFailure: { error in
                self.toggleProgress(false)
                DialogUtil.showOk(self, error.localizedDescription)
            }.disposed(by: bag)
    }
    
    private func save(subject:String,date:String,start:String,end:String,participants:[ParticipantModel])->Single<String>{
        let input = SaveReservationRequest(
            subject: subject,
            color: selectedColor,
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: allDay ? 1 : 0,
            locationID: Int(space?.spaceId ?? "0") ?? 0,
            locationName: space?.spaceName ?? "",
            participants: participants,
            serviceOptions: "{}",
            remind: reminderMinutes,
            carparkLocationId: nil,
            lockerLocationId: nil,
            virtualMeeting: virtualTextField.text,
            description: descriptionTextField.text)
        
        return BookingService.instance.saveReservation(input)
            .map { res in
                res.message
            }
        
    }
    
    private func update(id:String,subject:String,date:String,start:String,end:String,
                        participants:[ParticipantModel])->Single<String>{
        let input = UpdateReservationRequest(
            id:id,
            subject: subject,
            color: selectedColor,
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: allDay ? 1 : 0,
            locationID: Int(space?.spaceId ?? "0") ?? 0,
            locationName: space?.spaceName ?? "",
            participants: participants,
            serviceOptions: "{}",
            remind: reminderMinutes,
            carparkLocationId: nil,
            lockerLocationId: nil,
            virtualMeeting: virtualTextField.text,
            description: descriptionTextField.text)
        
        return BookingService.instance.updateReservation(input)
            .map { res in
                res.message
            }
    }
    
    private func toggleProgress(_ show:Bool){
        loadingView.isHidden = !show
        rootStackView.alpha = show ? 0.5 : 1
    }
    
    private func subject()->Single<String>{
        let subject=subjectTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if subject.isEmpty{
            return Single.error(NSError())
        }
        return Single.just(subject)
    }
    
    
}
