import Foundation
import Alamofire

struct GetAutoSpaceInput {
    let locationType: String
    let planDate: String
    let sTime: String
    let eTime: String
    let capacity:Int
}

struct SaveMyOfficeInput {
    let campusId: String
    let buildingId: String
    let floorId: String
}

struct SaveMyOfficeResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
    let status: Bool
}

struct GetBuildingListInput {
    let campusId: String
}

struct GetFloorListInput {
    let buildingId: String
}

struct SaveProfilePhotoResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
    let status: Bool
}

struct ParticipantModel: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case email = "EMail"
        case name = "Name"
        case surname = "Surname"
        case profilePhoto = "ProfilePhoto"
        case companyId = "CompanyID"
        case companyName = "CompanyName"
    }
    
    let id: String
    let email: String
    let name: String
    let surname: String?
    let profilePhoto: String?
    let companyId: String?
    let companyName: String?
    
    var fullname:String{
        get {
            return "\(name) \(surname ?? "")"
        }
    }
}

struct SaveOfficeReservationInput: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case subject = "Subject"
        case color = "Color"
        case planDate = "PlanDate"
        case sTime = "STime"
        case eTime = "ETime"
        case isAllDay = "IsAllDay"
        case locationID = "LocationID"
        case locationName = "LocationName"
        case serviceOptions = "ServiceOptions"
        case remind = "Remind"
        case carparkLocationId = "CarparkLocationID"
        case lockerLocationId = "LockerLocationID"
    }
    let subject: String
    let color: String
    let planDate: String
    let sTime: String
    let eTime: String
    let isAllDay: Int
    let locationID: Int
    let locationName: String
    let serviceOptions: [String:String]?
    let remind: Int
    let carparkLocationId: Int?
    let lockerLocationId: Int?
}


struct UpdateReservationInput: Encodable {
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case subject = "Subject"
        case color = "Color"
        case planDate = "PlanDate"
        case sTime = "STime"
        case eTime = "ETime"
        case isAllDay = "IsAllDay"
        case locationID = "LocationID"
        case locationName = "LocationName"
        case serviceOptions = "ServiceOptions"
        case remind = "Remind"
    }
    let id: String
    let subject: String
    let color: String
    let planDate: String
    let sTime: String
    let eTime: String
    let isAllDay: Int
    let locationID: Int
    let locationName: String
    let serviceOptions: [String:String]?
    let remind: Int
}

struct SaveReservationResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case reservationID = "ReservationID"
    }
    
    let status: Bool
    let message: String
    let reservationID: String?
}


struct SearchParticipantInput {
    let searchText: String
}

struct FollowUserInput: Encodable {
    public enum CodingKeys: String, CodingKey {
        case email = "EMail"
        case isFollow = "IsFollow"
    }
    let email: String
    let isFollow: Bool
}

struct FollowUserResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
    
    let status: Bool
    let message: String
}

struct SearchBookingByEmailInput {
    let email: String
}

struct GetBookingInput {
    let id: String
}

struct SearchBookingOfficeInput: Encodable {
    public enum CodingKeys: String, CodingKey {
        case campusID = "CampusID"
        case buildingID = "BuildingID"
        case floorID = "FloorID"
    }
    
    let campusID: String
    let buildingID: String
    let floorID: String
}

struct SearchBookingInput: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case isInDepartment = "IsInDepartment"
        case office = "Office"
        case locationType = "LocationType"
        case layoutID = "LayoutID"
        case equipmentIDs = "EquipmentIDs"
        case capacity = "Capacity"
        case planDate = "PlanDate"
        case sTime = "STime"
        case eTime = "ETime"
    }
    
    let isInDepartment: Bool
    let office: SearchBookingOfficeInput
    let locationType: String
    let layoutID: String
    let equipmentIDs: [String]
    let capacity: String
    let planDate: String
    let sTime: String
    let eTime: String
}

struct GiveFeedbackInput {
    let subject: String
    let message: String
}

struct GiveFeedbackResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
    let status: Bool
}

struct GetLocationInput {
    let locationId: String
}

struct GetMyFavoriteListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case recentlyUsed = "recentlyUsed"
        case mostlyUsed = "mostlyUsed"
        case favorites = "favorites"
    }
    let recentlyUsed: DecodedSearchBookingResponse?
    let mostlyUsed: DecodedSearchBookingResponse?
    let favorites: DecodedSearchBookingResponse?
}

struct SearchBookingResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case groupID = "GroupID"
        case groupName = "GroupName"
        case groupLink = "GroupLink"
        case occasions = "Occasions"
    }
    let groupID: String?
    let groupName: String?
    let groupLink: String?
    let occasions: [SpaceModel]?
}

struct DecodedSearchBookingResponse: Decodable {
    var bookingGroups: [SearchBookingResponse]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var tempArray = [SearchBookingResponse]()
        for key in container.allKeys {
            let decodedObject = try container.decode(SearchBookingResponse.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        bookingGroups = tempArray
    }
}

struct SetReservationInput {
    let status: String
    let meetingPlanId: String
    let meetingRoomId: String
}

struct SetReservationResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case status = "status"
        case textStatus = "textStatus"
    }
    
    let status: String?
    let textStatus: String?
}

struct ExtendMeetingPlanInput {
    let meetingPlanId: String
    let minute: Int
}

struct ExtendMeetingPlanResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
    
    let status: Bool?
    let message: String?
}

struct AddFavoriteInput {
    let roomId: Int
}

struct AddFavoriteResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
    
    let status: Bool?
}

struct RemoveFavoriteInput {
    let roomId: Int
}

struct RemoveFavoriteResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
    
    let status: Bool?
}

struct AcceptPrivacyPolicyResponse: Decodable {
    
}

struct GetCompanyServiceOptionsInput: Decodable {
}

struct GetAvailableCarParksInput: Decodable {
    let planDate: String
    let sTime: String
    let eTime: String
}

struct GetAvailableLockersInput: Decodable {
    let planDate: String
    let sTime: String
    let eTime: String
}

struct GetCompanyServiceOptionsResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case status = "Status"
        case isMandatory = "IsMandatory"
        case type = "Type"
        case companyID = "CompanyID"
    }
    
    let id: String?
    let name: String?
    let status: String?
    let isMandatory: String?
    let type: String?
    let companyID: String?

    func mapDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = self.id ?? "-1"
        dict["name"] = self.name ?? ""
        dict["status"] = self.status ?? "0"
        dict["isMandatory"] = self.isMandatory ?? "0"
        dict["type"] = self.type ?? "-1"
        dict["companyID"] = self.companyID ?? "-1"
        return dict
    }
}

struct GetAvailableCarParksResponse: Encodable {
    
}

struct GetAvailableLockersResponse: Encodable {
    
}

protocol BookreenServiceProtocol: AnyObject {
    func getEmployees(completion: @escaping (RestApiServiceResult<[EmployeeModel]?>) -> Void)
    func addFavorite(input: AddFavoriteInput, completion: @escaping (RestApiServiceResult<AddFavoriteResponse?>) -> Void)
    func removeFavorite(input: RemoveFavoriteInput, completion: @escaping (RestApiServiceResult<RemoveFavoriteResponse?>) -> Void)
    func extendMeetingPlan(input: ExtendMeetingPlanInput, completion: @escaping(RestApiServiceResult<ExtendMeetingPlanResponse?>) -> Void)
    func setReservation(input: SetReservationInput, completion: @escaping(RestApiServiceResult<SetReservationResponse?>) -> Void)
    func getMyFavorites(completion: @escaping(RestApiServiceResult<GetMyFavoriteListResponse>) -> Void)
    func getLocation(input: GetLocationInput, completion: @escaping(RestApiServiceResult<SpaceModel?>) -> Void)
    func followUser(input: FollowUserInput, completion: @escaping(RestApiServiceResult<FollowUserResponse>) -> Void)
    func getMyFriends(completion: @escaping(RestApiServiceResult<[EmployeeModel]>) -> Void)
    func saveProfilePhoto(baseEncodedImage: String, completion: @escaping (RestApiServiceResult<SaveProfilePhotoResponse>) -> Void)
    func getCampusList(completion: @escaping(RestApiServiceResult<[CampusModel]>) -> Void)
    func getBuildingList(input: GetBuildingListInput, completion: @escaping(RestApiServiceResult<[BuildingModel]>) -> Void)
    func getFloorList(input: GetFloorListInput, completion: @escaping(RestApiServiceResult<[FloorModel]>) -> Void)
    func getAllEvents(completion: @escaping(RestApiServiceResult<GetAllEventResponse>) -> Void)
    func getAutoSpace(input: GetAutoSpaceInput, completion: @escaping(RestApiServiceResult<SpaceModel>) -> Void)
    func saveMyOffice(input: SaveMyOfficeInput, completion: @escaping(RestApiServiceResult<SaveMyOfficeResponse>) -> Void)
    func saveReservation(input: SaveOfficeReservationInput, completion: @escaping(RestApiServiceResult<SaveReservationResponse>) -> Void)
    func updateReservation(input: UpdateReservationInput, completion: @escaping(RestApiServiceResult<UpdateReservationResponse>) -> Void)
    func searchParticipant(input: SearchParticipantInput, completion: @escaping(RestApiServiceResult<[ParticipantModel]>) -> Void)
    func searchBookingByEmail(input: SearchBookingByEmailInput, completion: @escaping(RestApiServiceResult<[BookingModel]>) -> Void)
    func getBooking(input: GetBookingInput, completion: @escaping(RestApiServiceResult<BookingModel>) -> Void)
    func searchBooking(input: SearchBookingInput, completion: @escaping(RestApiServiceResult<[SearchBookingResponse]>) -> Void)
    func giveFeedback(input: GiveFeedbackInput, completion: @escaping(RestApiServiceResult<GiveFeedbackResponse>) -> Void)
    func acceptPrivacyPolicy(completion: @escaping(RestApiServiceResult<AcceptPrivacyPolicyResponse>) -> Void)
    func getCompanyServiceOptions(input: GetCompanyServiceOptionsInput, completion: @escaping(RestApiServiceResult<[GetCompanyServiceOptionsResponse]>) -> Void)
    func getAvailableCarParks(input: GetAvailableCarParksInput, completion: @escaping(RestApiServiceResult<[GetAvailableCarParksResponse]>) -> Void)
    func getAvailableLockers(input: GetAvailableLockersInput, completion: @escaping(RestApiServiceResult<[GetAvailableLockersResponse]>) -> Void)
}

final class BookreenService: ApiService, BookreenServiceProtocol {
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func getCompanyServiceOptions(input: GetCompanyServiceOptionsInput, completion: @escaping (RestApiServiceResult<[GetCompanyServiceOptionsResponse]>) -> Void) {
        let urlAsString = BookreenEndpoint.getCompanyServiceOptions(token: self.token)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([GetCompanyServiceOptionsResponse]?.self, from: _data)
                    completion(.success("", response ?? []))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getAvailableLockers(input: GetAvailableLockersInput, completion: @escaping (RestApiServiceResult<[GetAvailableLockersResponse]>) -> Void) {
        let urlAsString = BookreenEndpoint.getAvailableLockers(token: self.token, planDate: input.planDate, sTime: input.sTime, eTime: input.eTime)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
//                guard let _data = data else {
//                    completion(.failure(AppError.nullData))
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    try decoder.configureDateParse()
//                    let response = try decoder.decode([EmployeeModel]?.self, from: _data)
//                    completion(.success("", response))
//                } catch {
//                    print(error)
//                    completion(.failure(AppError.serializationError(error.localizedDescription)))
//                }
                completion(.success("", []))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getAvailableCarParks(input: GetAvailableCarParksInput, completion: @escaping (RestApiServiceResult<[GetAvailableCarParksResponse]>) -> Void) {
        let urlAsString = BookreenEndpoint.getAvailableCarParks(token: self.token, planDate: input.planDate, sTime: input.sTime, eTime: input.eTime)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
//                guard let _data = data else {
//                    completion(.failure(AppError.nullData))
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    try decoder.configureDateParse()
//                    let response = try decoder.decode([EmployeeModel]?.self, from: _data)
//                    completion(.success("", response))
//                } catch {
//                    print(error)
//                    completion(.failure(AppError.serializationError(error.localizedDescription)))
//                }
                completion(.success("", []))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func acceptPrivacyPolicy(completion: @escaping (RestApiServiceResult<AcceptPrivacyPolicyResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.acceptPrivacyPolicy(token: self.token, status: "1")
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(_):
                completion(.success("", AcceptPrivacyPolicyResponse()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }

    }
    
    func getEmployees(completion: @escaping (RestApiServiceResult<[EmployeeModel]?>) -> Void) {
        let urlAsString = BookreenEndpoint.getEmployees(token: self.token)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([EmployeeModel]?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func addFavorite(input: AddFavoriteInput, completion: @escaping (RestApiServiceResult<AddFavoriteResponse?>) -> Void) {
        let urlAsString = BookreenEndpoint.addFavorite(token: self.token, roomId: input.roomId)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(AddFavoriteResponse?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func removeFavorite(input: RemoveFavoriteInput, completion: @escaping (RestApiServiceResult<RemoveFavoriteResponse?>) -> Void) {
        let urlAsString = BookreenEndpoint.removeFromFavorite(token: self.token, roomId: input.roomId)
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(RemoveFavoriteResponse?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func extendMeetingPlan(input: ExtendMeetingPlanInput, completion: @escaping (RestApiServiceResult<ExtendMeetingPlanResponse?>) -> Void) {
        let urlAsString = BookreenEndpoint.extendMeetingPlan(token: self.token, meetingPlanId: input.meetingPlanId, minute: input.minute)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(ExtendMeetingPlanResponse?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func setReservation(input: SetReservationInput, completion: @escaping (RestApiServiceResult<SetReservationResponse?>) -> Void) {
        let urlAsString = BookreenEndpoint.setReservation(token: self.token, status: input.status, meetingPlanId: input.meetingPlanId, meetingRoomId: input.meetingRoomId)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SetReservationResponse?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getLocation(input: GetLocationInput, completion: @escaping (RestApiServiceResult<SpaceModel?>) -> Void) {
        let urlAsString = BookreenEndpoint.getLocation(token: self.token, locationId: input.locationId)
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SpaceModel?.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func giveFeedback(input: GiveFeedbackInput, completion: @escaping (RestApiServiceResult<GiveFeedbackResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.giveFeedback(token: self.token)
        let parameters: [String: String] = [
            "Subject": input.subject,
            "Message": input.message
        ]
        
        self.sessionManager.request(urlAsString, method: .post, parameters: parameters).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(GiveFeedbackResponse.self, from: _data)
                    completion(.success("", apiResponse))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyFavorites(completion: @escaping (RestApiServiceResult<GetMyFavoriteListResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.myFavorites(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(GetMyFavoriteListResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func searchBooking(input: SearchBookingInput, completion: @escaping (RestApiServiceResult<[SearchBookingResponse]>) -> Void) {
        let urlAsString = BookreenEndpoint.searchBooking(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .post, parameters: input, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(DecodedSearchBookingResponse.self, from: _data)
                    completion(.success("", response.bookingGroups))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getBooking(input: GetBookingInput, completion: @escaping (RestApiServiceResult<BookingModel>) -> Void) {
        let urlAsString = "\(baseUrl)\(BookreenEndpoint.bookingDetail(token: self.token, id: input.id))"
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(BookingModel.self, from: _data)
                    completion(.success("", response))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchBookingByEmail(input: SearchBookingByEmailInput, completion: @escaping (RestApiServiceResult<[BookingModel]>) -> Void) {
        let urlAsString = BookreenEndpoint.searchBookingByEmail(token: self.token, email: input.email)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([BookingModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func followUser(input: FollowUserInput, completion: @escaping (RestApiServiceResult<FollowUserResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.followUser(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .post, parameters: input, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(FollowUserResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyFriends(completion: @escaping (RestApiServiceResult<[EmployeeModel]>) -> Void) {
        let urlAsString = BookreenEndpoint.getMyFriends(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([EmployeeModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func updateReservation(input: UpdateReservationInput, completion: @escaping (RestApiServiceResult<UpdateReservationResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.updateReservation(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .post, parameters: input, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(UpdateReservationResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchParticipant(input: SearchParticipantInput, completion: @escaping (RestApiServiceResult<[ParticipantModel]>) -> Void) {
        let urlEncoded = input.searchText.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let urlAsString = BookreenEndpoint.searchParticipant(token: self.token, searchText: urlEncoded)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([ParticipantModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
 
    func saveReservation(input: SaveOfficeReservationInput, completion: @escaping (RestApiServiceResult<SaveReservationResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.saveReservation(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .post, parameters: input, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SaveReservationResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func saveProfilePhoto(baseEncodedImage: String, completion: @escaping (RestApiServiceResult<SaveProfilePhotoResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.setProfilePhoto(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .post, parameters: [:], encoding: baseEncodedImage).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SaveProfilePhotoResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getCampusList(completion: @escaping (RestApiServiceResult<[CampusModel]>) -> Void) {
        let urlAsString = BookreenEndpoint.getCampusList(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([CampusModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getBuildingList(input: GetBuildingListInput, completion: @escaping (RestApiServiceResult<[BuildingModel]>) -> Void) {
        let campusId = input.campusId
        
        let urlAsString = BookreenEndpoint.getBuildingList(token: self.token, campusId: campusId)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([BuildingModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getFloorList(input: GetFloorListInput, completion: @escaping (RestApiServiceResult<[FloorModel]>) -> Void) {
        let buildingId = input.buildingId
        
        let urlAsString = BookreenEndpoint.getFloorList(token: self.token, buildingId: buildingId)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode([FloorModel].self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func saveMyOffice(input: SaveMyOfficeInput, completion: @escaping (RestApiServiceResult<SaveMyOfficeResponse>) -> Void) {
        let campusId = input.campusId
        let buildingId = input.buildingId
        let floorId = input.floorId
        
        let urlAsString = BookreenEndpoint.saveMyOffice(token: self.token, campusId: campusId, buildingId: buildingId, floorId: floorId)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SaveMyOfficeResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getAutoSpace(input: GetAutoSpaceInput, completion: @escaping (RestApiServiceResult<SpaceModel>) -> Void) {
        let locationType = input.locationType
        let planDate = input.planDate
        let startTime = input.sTime
        let endTime = input.eTime
        let urlAsString = BookreenEndpoint.getAutoSpace(token: self.token, locationType: locationType, planDate: planDate, startTime: startTime, endTime: endTime)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(SpaceModel.self, from: _data)
                    completion(.success("", response))
                } catch {
                    print(error)
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func getAllEvents(completion: @escaping (RestApiServiceResult<GetAllEventResponse>) -> Void) {
        let urlAsString = BookreenEndpoint.getAllEvents(token: self.token)
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        self.sessionManager.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let response = try decoder.decode(GetAllEventResponse.self, from: _data)
                    completion(.success("", response))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
