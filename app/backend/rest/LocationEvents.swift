//
//  LocationEvents.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import Foundation

struct LocationEvents : Decodable{
    enum CodingKeys : String , CodingKey{
        case location="Location"
        case maxDurationToNext="AvailableMaxDurationToNextEvent"
        case events="LocationEvents"
    }
    let location:SpaceModel
    let maxDurationToNext:String?
    var events:[LocationEvent]?
    
}

struct LocationEvent : Decodable{
    
    enum CodingKeys : String, CodingKey{
        case id="ID"
        case subject="Subject"
        case description="Description"
        case showBefore="ShowBefore"
        case showAfter="ShowAfter"
        case date="PlanDate"
        case start="STime"
        case end="ETime"
        case status="Status"
        case locationId="LocationID"
        case locationName="LocationName"
        case floorId="FloorID"
        case floorName="FloorName"
        case buildingId="BuildingID"
        case buildingName="BuildingName"
        case campusId="CampusID"
        case campusName="CampusName"
    }
    
    let id:String
    let subject:String
    let description:String?
    let showBefore:String?
    let showAfter:String?
    let date:String
    let start:String
    let end:String
    let status:String
    let locationId:String
    let locationName:String
    let floorId:String?
    let floorName:String?
    let buildingId:String?
    let buildingName:String?
    let campusId:String?
    let campusName:String?
    
    
    var fixedStart:String {
        get{
            var start=self.start
            if start.count > 5{
                let index=start.index(start.startIndex, offsetBy: 5)
                start=String(start[..<index])
            }
            return start
        }
    }
    
    var fixedEnd:String {
        get{
            var end=self.end
            if end.count > 5{
                let index=end.index(end.startIndex, offsetBy: 5)
                end=String(end[..<index])
            }
            return end
        }
    }
    
}
