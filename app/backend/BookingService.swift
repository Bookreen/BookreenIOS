//
//  BookingService.swift
//  Bookreen
//
//  Created by bullhead on 12/3/21.
//

import Foundation
import RxSwift
import Then

class BookingService{
    static let instance=BookingService()
    private let bg=ConcurrentDispatchQueueScheduler.init(qos: .background)
    private let main=MainScheduler.instance
    private let legacyService=BookreenService(token: SessionManager.shared.token)
    private let formatter=DateFormatter().then{
        $0.dateFormat="yyyy-MM-dd"
    }
    private let hourMinFormatter=DateFormatter().then {
        $0.dateFormat="HH:mm"
    }
    
    private init(){
        
    }
    
    func findAutoSpace(start:Date,end:Date,isAllDay:Bool,spaceType:SpaceType = .meeting,capacity:Int=1)->Single<ReservationSpaceModel>{
        return URLRequest(withMobile: "/getAutoSpace")
            .formEncoded(["LocationType":spaceType.rawValue,
                          "PlanDate":formatter.string(from: start),
                          "STime":isAllDay ? SessionManager.shared.workStartTime : hourMinFormatter.string(from: start),
                          "ETime":isAllDay ? SessionManager.shared.workEndTime : hourMinFormatter.string(from: end),
                          "Capacity":capacity])
            .perform(type: SpaceModel.self)
            .map({ model in
                return ReservationSpaceModel(spaceId: model.id, spaceName: model.name, campusId: model.campusId, campusName: model.campusName, buildingId: model.buildingId, buildingName: model.buildingName, floorId: model.floorId, floorName: model.floorName)
            })
            .subscribe(on: bg)
            .observe(on: main)
    }
    
    func saveReservation(_ input:SaveReservationRequest)->Single<SaveReservationResponse>{
        return URLRequest(withMobile: "/saveReservation?Token=\(SessionManager.shared.token)")
            .json(input)
            .perform(type: SaveReservationResponse.self)
            .flatMap({ res in
                if res.reservationID != nil {
                    return Single.just(res)
                } else {
                   return  Single.error(makeError(text: res.message))
                }
            })
        .subscribe(on: bg)
        .observe(on: main)
    }
    
    func saveDeskReservation(_ input:SaveOfficeReservationInput)->Single<SaveReservationResponse>{
        return URLRequest(withMobile: "/saveReservation?Token=\(SessionManager.shared.token)")
            .json(input)
            .perform(type: SaveReservationResponse.self)
            .flatMap({ res in
                if res.reservationID != nil {
                    return Single.just(res)
                } else {
                   return  Single.error(makeError(text: res.message))
                }
            })
        .subscribe(on: bg)
        .observe(on: main)
    }
    
    func updateReservation(_ request:UpdateReservationRequest)->Single<UpdateReservationResponse>{
        return URLRequest(withMobile: "/updateReservation?Token=\(SessionManager.shared.token)")
            .json(request)
            .perform(type: UpdateReservationResponse.self)
            .flatMap({ res in
                if res.reservationID != nil {
                    return Single.just(res)
                } else {
                   return  Single.error(makeError(text: res.message))
                }
            })
        .subscribe(on: bg)
        .observe(on: main)
    }
    
    func bookingDetails(id:String) -> Single<BookingModel> {
        return URLRequest(withMobile: "/bookingDetail?Token=\(SessionManager.shared.token)&ID=\(id)")
            .perform(type: BookingModel.self)
            .subscribe(on: bg)
            .observe(on: main)
    
    }
    
    
}
