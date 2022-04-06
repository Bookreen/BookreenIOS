import Foundation

public class SessionManager {
    
    private let _displayName = "displayName"
    private let _token = "token"
    private let _id = "id"
    private let _loginName = "loginName"
    private let _profilePhoto = "profilePhoto"
    private let _personId = "personId"
    private let _departmentId = "departmentId"
    private let _companyId = "companyId"
    private let _pin = "pin"
    private let _email = "email"
    private let _hashedInvitationCode = "hashedInvitationCode"
    private let _phone = "phone"
    private let _language = "language"
    private let _workStartTime = "workStartTime"
    private let _workEndTime = "workEndTime"
    private let _lunchStartTime = "lunchStartTime"
    private let _lunchEndTime = "lunchEndTime"
    private let _officeDays = "officeDays"
    private let _companyName = "companyName"
    private let _campusId: String = "campusId"
    private let _buildingId: String = "buildingId"
    private let _floorId: String = "floorId"
    private let _campusName: String = "campusName"
    private let _buildingName: String = "buildingName"
    private let _floorName: String = "floorName"
    private let _departmentName: String = "departmentName"
    private let _departmentOfficeDays: String = "departmentOfficeDays"
    private let _name: String = "name"
    private let _surname: String = "surname"
    private let _username: String = "username"
    private let _password: String = "password"
    private let _isShowLocationPermission: String = "isShowLocationPermission"
    private let _qrCheckin="qr_check_in"
    
    public static let shared = SessionManager()

    private init() {}
    
    public var token: String {
        get {
            return UserDefaults.standard.string(forKey: _token) ?? "asd"
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _token)
        }
    }
    
    var qrCheckin:String{
        get {
            return UserDefaults.standard.string(forKey: _qrCheckin) ?? ""
        }
        set(value){
            UserDefaults.standard.setValue(value, forKey: _qrCheckin)
        }
    }
    
    public var id: String {
        get {
            return UserDefaults.standard.string(forKey: _id) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _id)
        }
    }
    
    public var loginName: String {
        get {
            return UserDefaults.standard.string(forKey: _loginName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _loginName)
        }
    }
    
    public var profilePhoto: String {
        get {
            return UserDefaults.standard.string(forKey: _profilePhoto) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _profilePhoto)
        }
    }
    
    public var personId: String {
        get {
            return UserDefaults.standard.string(forKey: _personId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _personId)
        }
    }
    
    public var departmentId: String {
        get {
            return UserDefaults.standard.string(forKey: _departmentId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _departmentId)
        }
    }
    
    public var companyId: String {
        get {
            return UserDefaults.standard.string(forKey: _companyId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _companyId)
        }
    }
    
    public var pin: String {
        get {
            return UserDefaults.standard.string(forKey: _pin) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _pin)
        }
    }
    
    public var hashedInvitationCode: String {
        get {
            return UserDefaults.standard.string(forKey: _hashedInvitationCode) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _hashedInvitationCode)
        }
    }
    
    public var phone: String {
        get {
            return UserDefaults.standard.string(forKey: _phone) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _phone)
        }
    }
    
    public var language: String {
        get {
            return UserDefaults.standard.string(forKey: _language) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _language)
        }
    }
    
    public var displayName: String {
        get {
            return UserDefaults.standard.string(forKey: _displayName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _displayName)
        }
            
    }
    
    public var name: String {
        get {
            return UserDefaults.standard.string(forKey: _name) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _name)
        }
            
    }
    
    public var surname: String {
        get {
            return UserDefaults.standard.string(forKey: _surname) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _surname)
        }
            
    }
    
    public var username: String {
        get {
            return UserDefaults.standard.string(forKey: _username) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _username)
        }
            
    }
    
    public var password: String {
        get {
            return UserDefaults.standard.string(forKey: _password) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _password)
        }
            
    }
    
    public var email: String {
        get {
            return UserDefaults.standard.string(forKey: _email) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _email)
        }
            
    }
    
    public var workStartTime: String {
        get {
            return UserDefaults.standard.string(forKey: _workStartTime) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _workStartTime)
        }
            
    }
    
    public var workEndTime: String {
        get {
            return UserDefaults.standard.string(forKey: _workEndTime) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _workEndTime)
        }
            
    }
    
    public var lunchStartTime: String {
        get {
            return UserDefaults.standard.string(forKey: _lunchStartTime) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _lunchStartTime)
        }
            
    }
    
    public var lunchEndTime: String {
        get {
            return UserDefaults.standard.string(forKey: _lunchEndTime) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _lunchEndTime)
        }
            
    }
    
    public var officeDays: String {
        get {
            return UserDefaults.standard.string(forKey: _officeDays) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _officeDays)
        }
            
    }
    
    public var companyName: String {
        get {
            return UserDefaults.standard.string(forKey: _companyName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _companyName)
        }
            
    }
    
    public var campusId: String {
        get {
            return UserDefaults.standard.string(forKey: _campusId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _campusId)
        }
            
    }
    
    public var buildingId: String {
        get {
            return UserDefaults.standard.string(forKey: _buildingId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _buildingId)
        }
            
    }
    
    public var floorId: String {
        get {
            return UserDefaults.standard.string(forKey: _floorId) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _floorId)
        }
            
    }
    
    public var campusName: String {
        get {
            return UserDefaults.standard.string(forKey: _campusName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _campusName)
        }
            
    }
    
    public var buildingName: String {
        get {
            return UserDefaults.standard.string(forKey: _buildingName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _buildingName)
        }
            
    }
    
    public var floorName: String {
        get {
            return UserDefaults.standard.string(forKey: _floorName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _floorName)
        }
            
    }
    
    public var departmentName: String {
        get {
            return UserDefaults.standard.string(forKey: _departmentName) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _departmentName)
        }
            
    }
    
    public var departmentOfficeDays: String {
        get {
            return UserDefaults.standard.string(forKey: _departmentOfficeDays) ?? ""
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _departmentOfficeDays)
        }
            
    }
    
    public var isShowLocationPermission: Bool {
        get {
            return UserDefaults.standard.bool(forKey: _isShowLocationPermission)
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: _isShowLocationPermission)
        }
    }
    
    func setUser(_ user: UserModel) {
        self.id = user.id
        self.loginName = user.loginName
        self.profilePhoto = user.profilePhoto ?? ""
        self.personId = user.personId ?? ""
        self.departmentId = user.departmentId ?? ""
        self.companyId = user.companyId ?? ""
        self.displayName = "\(user.name) \(user.surname)"
        self.name = user.name
        self.surname = user.surname
        self.email = user.email ?? ""
        self.pin = user.pin ?? ""
        self.hashedInvitationCode = user.hashedInvitationCode ?? ""
        self.phone = user.phone ?? ""
        self.language = user.language ?? ""
        
        self.campusId = ""
        self.buildingId = ""
        self.floorId = ""
        let myOfficeAsString = user.myOffice ?? ""
        if myOfficeAsString.count > 0 {
            do {
                let data = myOfficeAsString.data(using: .utf8)
                if let _data = data {
                    let jsonDecoder = JSONDecoder()
                    let myOffice = try jsonDecoder.decode(MyOfficeModel.self, from: _data)
                    
                    self.campusId = myOffice.campusID ?? ""
                    self.buildingId = myOffice.buildingID ?? ""
                    self.floorId = myOffice.floorID ?? ""
                    
                }
            } catch {
                print(error)
            }
        }
    }
    
    func setCompany(_ company: CompanyModel) {
        self.workStartTime = company.workStartTime ?? "08:00"
        self.workEndTime = company.workEndTime ?? "12:00"
        self.lunchStartTime = company.lunchStartTime ?? "13:00"
        self.lunchEndTime = company.lunchEndTime ?? "17:00"
        self.officeDays = company.officeDays ?? "[]"
        self.companyName = company.name ?? ""
    }
    
    
    func setDepartment(_ department: DepartmentModel?) {
        self.departmentName = department?.name ?? ""
        self.departmentOfficeDays = department?.officeDays ?? ""
    }
    
    func setDisplaySettings(_ settings:DisplaySettings?){
        self.qrCheckin=settings?.qrCheckin ?? ""
    }
    
    public func logout() {
        self.username = ""
        self.password = ""
        self.companyId = ""
        self.buildingId = ""
        self.floorId = ""
        self.id = ""
        self.loginName = ""
        self.profilePhoto = ""
        self.personId = ""
        self.departmentId = ""
        self.companyId = ""
        self.displayName = ""
        self.email = ""
        self.pin = ""
        self.hashedInvitationCode = ""
        self.phone = ""
        self.language = ""
        self.workStartTime = ""
        self.workEndTime = ""
        self.lunchStartTime = ""
        self.lunchEndTime = ""
        self.officeDays = ""
        self.companyName = ""
        self.departmentOfficeDays = ""
    }
}
