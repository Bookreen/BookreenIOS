//
//  QrReservationViewController+Reservation.swift
//  Bookreen
//
//  Created by bullhead on 12/10/21.
//

import Foundation
import RxSwift
import Then

extension QrReservationViewController{
    
    func reserve(){
        guard let info = self.info,minutesSegments.isEnabled else {
            DialogUtil.showOk(self, S.notAvailableBookingMessage.localized().replacingOccurrences(of: "%s", with: ""))
            return
        }
        let date=Calendar.current.date(byAdding: .minute, value: 2, to: Date())!
        let d=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd"
        }.string(from: Date())
        let h=DateFormatter().then {
            $0.dateFormat="HH:mm"
        }
        let start=h.string(from: date)
        let end:String
        if minutesSegments.selectedSegmentIndex == 4{
            end=SessionManager.shared.workEndTime
        }else{
            let index=minutesSegments.selectedSegmentIndex
            let endDate=Calendar.current.date(byAdding: .minute, value: getMinutes(for: index), to: date)!
            end=h.string(from: endDate)
        }
        let call:Single<String>
        if info.location.meetingRoomTypeId != nil{
            call = bookMeeting(space: info.location,date: d,start: start,end: end)
        }else{
            call = bookOffice(location: info.location,date: d,start: start,end: end)
        }
        
        NotificationCenter.default.post(name: .showLoadingView, object: self)
        call.subscribe { message in
            NotificationCenter.default.post(name: .dismissLoadingView, object: self)
            DialogUtil.showOk(self, message) {
                self.navigationController?.popViewController(animated: true)
            }
        } onFailure: { error in
            NotificationCenter.default.post(name: .dismissLoadingView, object: self)
            DialogUtil.showOk(self, error.localizedDescription)
        }.disposed(by: bag)

        
    }
    
    private func getMinutes(for index:Int)->Int{
        if index==0{
            return 30
        }else if index==1{
            return 45
        }else if index==2{
            return 60
        }
        return 120
    }
    
    private func bookMeeting(space:SpaceModel,date:String,start:String,end:String)->Single<String>{
        let input = SaveReservationRequest(
            subject: S.instantReservation.localized(),
            color: "#4caf50",
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: minutesSegments.selectedSegmentIndex==4 ? 1 : 0,
            locationID: Int(space.id ?? "0") ?? 0,
            locationName: space.name ?? "",
            participants: [],
            serviceOptions: "{}",
            remind: 15,
            carparkLocationId: nil,
            lockerLocationId: nil,
            virtualMeeting: "",
            description: "")
        
        return BookingService.instance.saveReservation(input)
            .map { res in
                res.message
            }
    }
    
    private func bookOffice(location:SpaceModel,date:String,start:String,end:String)->Single<String>{
        let input = SaveOfficeReservationInput(
            subject: S.instantReservation.localized(),
            color: "#4caf50",
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: minutesSegments.selectedSegmentIndex==4 ? 1 : 0,
            locationID: Int(location.id ?? "0") ?? 0,
            locationName: location.name ?? "",
            serviceOptions:[String:String](),
            remind: 15,
            carparkLocationId: 0,
            lockerLocationId: 0
        )
        return BookingService.instance.saveDeskReservation(input)
            .map { res in
                res.message
            }
    }
}
