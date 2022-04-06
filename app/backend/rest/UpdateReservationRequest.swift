//
//  UpdateReservationRequest.swift
//  Bookreen
//
//  Created by bullhead on 12/8/21.
//

import Foundation
struct UpdateReservationRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case id="ID"
        case subject = "Subject"
        case color = "Color"
        case planDate = "PlanDate"
        case sTime = "STime"
        case eTime = "ETime"
        case isAllDay = "IsAllDay"
        case locationID = "LocationID"
        case locationName = "LocationName"
        case participants = "Participants"
        case serviceOptions = "ServiceOptions"
        case remind = "Remind"
        case carparkLocationId = "CarparkLocationID"
        case lockerLocationId = "LockerLocationID"
        case virtualMeeting = "VirtualMeetings"
        case  description = "Description"
    }
    let id:String
    let subject: String
    let color: String
    let planDate: String
    let sTime: String
    let eTime: String
    let isAllDay: Int
    let locationID: Int
    let locationName: String
    let participants: [ParticipantModel]
    let serviceOptions: String?
    let remind: Int
    let carparkLocationId: Int?
    let lockerLocationId: Int?
    let virtualMeeting:String?
    let description:String?
}

struct UpdateReservationResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case reservationID = "ReservationID"
    }
    
    let status: Bool
    let message: String
    let reservationID: String?
}
