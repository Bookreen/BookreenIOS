import Foundation

class BookingModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case campusId = "CampusID"
        case campusName = "CampusName"
        case buildingId = "BuildingID"
        case buildingName = "BuildingName"
        case floorId = "FloorID"
        case floorName = "FloorName"
        case spaceId = "SpaceID"
        case spaceName = "SpaceName"
        case spaceTypeId = "SpaceTypeId"
        case subject = "Subject"
        case description = "Description"
        case organizer = "Organizer"
        case asParticipant = "AsParticipant"
        case participantCount = "ParticipantCount"
        case id = "ID"
        case planDate = "PlanDate"
        case startTime = "STime"
        case endTime = "ETime"
        case status = "Status"
        case statusText = "StatusText"
        case meetingOrganizer = "MeetingOrganizer"
        case logicalStatus = "LogicalStatus"
        case checkinStartTime = "CheckinStartTime"
        case checkinEndTime = "CheckinEndTime"
        case isInCheckinTime = "IsInCheckinTime"
        case locationName = "LocationName"
        case color="Color"
        case participants="Participants"
        case virtualLink="VirtualMeetings"
        case remind="Remind"
    }

    let campusId: String?
    let campusName: String?
    let buildingId: String?
    let buildingName: String?
    let floorId: String?
    let floorName: String?
    let spaceId: String?
    let spaceName: String?
    let spaceTypeId: String?
    let subject: String?
    let description: String?
    let organizer: String?
    let asParticipant: Bool?
    let participantCount: String?
    let id: String?
    let planDate: String?
    let startTime: String?
    let endTime: String?
    let status: String?
    let statusText: String?
    let meetingOrganizer: String?
    let logicalStatus: String?
    let checkinStartTime: String?
    let checkinEndTime: String?
    let isInCheckinTime: Bool?
    let locationName: String?
    var bookingStatus: BookingStatus = .upcomingEvents
    var color:String?
    var participants:[ParticipantModel]?
    var virtualLink:String?
    let remind:String?
    
    var remindMintes:Int{
        if let remind = remind {
            return Int(remind) ?? 15
        }
        return 15
    }
    
}
