import Foundation

struct MyOfficeModel: Decodable {
    public enum CodingKeys: String, CodingKey {
        case campusID = "CampusID"
        case buildingID = "BuildingID"
        case floorID = "FloorID"
    }
    
    let campusID: String?
    let buildingID: String?
    let floorID: String?
}
