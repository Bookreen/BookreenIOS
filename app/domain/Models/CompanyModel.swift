import Foundation

struct CompanyModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case workStartTime = "WorkStartTime"
        case workEndTime = "WorkEndTime"
        case lunchStartTime = "LunchStartTime"
        case lunchEndTime = "LunchEndTime"
        case officeDays = "OfficeDays"
        case name = "Name"
    }
    let id: String
    let workStartTime: String?
    let workEndTime: String?
    let lunchStartTime: String?
    let lunchEndTime: String?
    let officeDays: String?
    let name: String?
}
