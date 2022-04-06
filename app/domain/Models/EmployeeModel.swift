import Foundation

struct EmployeeModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case email = "EMail"
        case name = "Name"
        case surname = "Surname"
        case profilePhoto = "ProfilePhoto"
        case companyId = "CompanyID"
        case companyName = "CompanyName"
    }
    
    let id: String?
    let email: String?
    let name: String?
    let surname: String?
    let profilePhoto: String?
    let companyId: String?
    let companyName: String?
}
