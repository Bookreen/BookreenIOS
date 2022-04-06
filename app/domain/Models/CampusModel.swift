import Foundation

struct CampusModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case description = "Description"
        case status = "Status"
        case cUser = "CUser"
        case cDate = "CDate"
        case mUser = "MUser"
        case mDate = "MDate"
        case code = "Code"
        case name = "Name"
        case address = "Address"
        case timeZoneID = "TimeZoneID"
        case imageID = "ImageID"
        case screenLanguage = "ScreenLanguage"
    }
    
    let id: String
    let description: String?
    let status: String
    let cUser: String
    let cDate: String
    let mUser: String?
    let mDate: String?
    let code: String
    let name: String
    let address: String?
    let timeZoneID: String
    let imageID: String
    let screenLanguage: String
}
