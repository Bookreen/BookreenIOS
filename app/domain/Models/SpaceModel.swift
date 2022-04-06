import Foundation

class SpaceModel: Codable {
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case status = "Status"
        case name = "Name"
        case code = "Code"
        case campusId = "CampusID"
        case campusName = "CampusName"
        case buildingId = "BuildingID"
        case buildingName = "BuildingName"
        case floorId = "FloorID"
        case floorName = "FloorName"
        case typeName = "TypeName"
        case layout = "Layout"
        case capacity = "Capacity"
        case isMyFavorite = "IsMyFavorite"
        case isRecently = "IsRecently"
        case isMostly = "IsMostly"
        case mediaFilePath = "MediaFilePath"
        case address = "Address"
        case days = "Days"
        case layoutId = "LayoutID"
        case usageTypeId = "UsageTypeID"
        case fixedUserId = "FixedUserID"
        case meetingRoomTypeId = "MeetingRoomTypeID"
        case meetingRoomEqId = "MeetingRoomEqID"
        case meetingRoomSeId = "MeetingRoomSeID"
        
    }
    
    let id: String?
    let status: String?
    let name: String?
    let code: String?
    let campusId: String?
    let campusName: String?
    let buildingId: String?
    let buildingName: String?
    let floorId: String?
    let floorName: String?
    let typeName: String?
    let layout: String?
    let capacity: String?
    var isMyFavorite: String?
    let isRecently: String?
    let isMostly: String?
    let mediaFilePath: String?
    let address: String?
    let days: String?
    let layoutId: String?
    let usageTypeId: String?
    let fixedUserId: String?
    let meetingRoomTypeId: String?
    let meetingRoomEqId: String?
    let meetingRoomSeId: String?
    
    func locationDescription()->String{
        let campusName = self.campusName ?? ""
        let buildingName = self.buildingName ?? ""
        let floorName = self.floorName ?? ""
        return "\(campusName), \(buildingName), \(floorName)"
    }
}
