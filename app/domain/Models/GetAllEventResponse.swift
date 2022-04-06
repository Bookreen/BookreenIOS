import Foundation

struct GetAllEventResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case eventCheckin = "eventCheckin"
        case checkinStart = "checkinStart"
        case checkinEnd = "checkinEnd"
        case ongoingEvents = "ongoingEvents"
        case checkinWaitingEvents = "checkinWaitingEvents"
        case notCheckedinEvents = "notCheckedinEvents"
        case upcomingEvents = "upcomingEvents"
    }
    
    let eventCheckin: Bool
    let checkinStart: String
    let checkinEnd: String
    let ongoingEvents: [BookingModel]?
    let checkinWaitingEvents: [BookingModel]?
    let notCheckedinEvents: [BookingModel]?
    let upcomingEvents: [BookingModel]?
}
