import Foundation

struct DepartmentModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case manager = "Manager"
        case workers = "Workers"
        case officeDays = "OfficeDays"
        case name = "Name"
        case id = "ID"
        case limitType = "LimitType"
        case limitValueCapacity = "LimitValueCapacity"
        case limitValueCount = "LimitValueCount"
        case reservationRequest = "ReservationRequest"
    }
    
    let manager: ManagerModel?
    let workers: [WorkerModel]?
    let officeDays: String?
    let name: String
    let id: String
    let limitType: String
    let limitValueCapacity: String
    let limitValueCount: String
    let reservationRequest: String?
}
