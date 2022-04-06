import Foundation

struct UserModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case loginName = "LoginName"
        case name = "Name"
        case surname = "Surname"
        case profilePhoto = "ProfilePhoto"
        case personId = "PersonID"
        case departmentId = "DepartmentID"
        case companyId = "CompanyID"
        case email = "EMail"
        case pin = "PIN"
        case hashedInvitationCode = "HashedInvitationCode"
        case phone = "Phone"
        case language = "Language"
        case myOffice = "MyOffice"
        case kvkkConfirmation = "KvkkConfirmation"
    }
    
    let id: String
    let loginName: String
    let name: String
    let surname: String
    let profilePhoto: String?
    let personId: String?
    let departmentId: String?
    let companyId: String?
    let email: String?
    let pin: String?
    let hashedInvitationCode: String?
    let phone: String?
    let language: String?
    let myOffice: String?
    let kvkkConfirmation: String?
    
    func isKvkkConfirmation() -> Bool {
        let kvkkConfirmationStatus = self.kvkkConfirmation ?? "0"
        return kvkkConfirmationStatus == "1"
    }
    
    func isExistsMyOffice() -> Bool {
        let myOfficeResult = self.myOffice ?? ""
        return !myOfficeResult.isEmpty
    }
}
