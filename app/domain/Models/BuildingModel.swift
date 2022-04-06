import Foundation

struct BuildingModel: Decodable {
    
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
        case imageID = "ImageID"
        case campusID = "CampusID"
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
    let imageID: String
    let campusID: String
}
