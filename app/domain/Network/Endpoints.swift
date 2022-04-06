import Foundation

let baseUrl = "https://space.bookreen.com"

class AuthEndpoint {
    static let login = "/mobile/login"
    static let setPasswordForThisOnce = "/mobile/setPasswordForThisOnce"
    static func forgotPassword(token: String, email: String) -> String {
        return "\(baseUrl)/mobile/forgotPassword?Token=\(token)&EMail=\(email)"
    }
    static func logout(token: String) -> String {
        return "\(baseUrl)/mobile/logout?Token=\(token)"
    }
}

class BookreenEndpoint {
    
    static func getCompanyServiceOptions(token: String) -> String {
        return "\(baseUrl)/mobile/getCompanyServiceOptions?Token=\(token)"
    }
    
    static func getAvailableLockers(token: String, planDate: String, sTime: String, eTime: String) -> String {
        return "\(baseUrl)/mobile/getAvailableLockers?Token=\(token)&PlanDate=\(planDate)&STime=\(sTime)&ETime=\(eTime)"
    }
    
    
    static func getAvailableCarParks(token: String, planDate: String, sTime: String, eTime: String) -> String {
        return "\(baseUrl)/mobile/getAvailableCarParks?Token=\(token)&PlanDate=\(planDate)&STime=\(sTime)&ETime=\(eTime)"
    }
    
    
    static func acceptPrivacyPolicy(token: String, status: String) -> String {
        return "\(baseUrl)/mobile/setKvkkConfirmation?Token=\(token)&KvkkConfirmation=\(status)"
    }
    
    static func getEmployees(token: String) -> String {
        return "\(baseUrl)/mobile/getEmployees?Token=\(token)"
    }
    
    static func setProfilePhoto(token: String) -> String {
        return "\(baseUrl)/mobile/setProfilePhoto?Token=\(token)"
    }
    
    static func giveFeedback(token: String) -> String {
        return "\(baseUrl)/mobile/giveFeedback?Token=\(token)"
    }
    
    static func getCampusList(token: String) -> String {
        return "\(baseUrl)/mobile/campuses?Token=\(token)"
    }
    
    static func getBuildingList(token: String, campusId: String) -> String {
        return "\(baseUrl)/mobile/buildings?Token=\(token)&CampusID=\(campusId)"
    }
    
    static func getFloorList(token: String, buildingId: String) -> String {
        return "\(baseUrl)/mobile/floors?Token=\(token)&BuildingID=\(buildingId)"
    }
    
    static func saveMyOffice(token: String, campusId: String, buildingId: String, floorId: String) -> String {
        return "\(baseUrl)/mobile/saveMyOffice?Token=\(token)&CampusID=\(campusId)&BuildingID=\(buildingId)&FloorID=\(floorId)"
    }

    static func getLocation(token: String, locationId: String) -> String {
        return "\(baseUrl)/mobile/getLocation?Token=\(token)&LocationID=\(locationId)"
    }
    
    static let getLocationEvents = "/mobile/getLocationEvents"
    
    static func getAllEvents(token: String) -> String {
        return "\(baseUrl)/mobile/getAllEvents?Token=\(token)"
    }
    
    static func searchBooking(token: String) -> String {
        return "\(baseUrl)/mobile/searchBooking?Token=\(token)"
    }
    
    static func getAutoSpace(token: String, locationType: String, planDate: String, startTime: String, endTime: String) -> String {
        return "\(baseUrl)/mobile/getAutoSpace?Token=\(token)&LocationType=\(locationType)&PlanDate=\(planDate)&STime=\(startTime)&ETime=\(endTime)"
    }
    
    static func searchParticipant(token: String, searchText: String) -> String {
        return "\(baseUrl)/mobile/searchParticipant?Token=\(token)&SearchText=\(searchText)"
    }
    
    static func searchBookingByEmail(token: String, email: String) -> String {
        return "\(baseUrl)/mobile/searchBookingByEmail?Token=\(token)&Email=\(email)"
    }
    
    static func myFavorites(token: String) -> String {
        return "\(baseUrl)/mobile/myFavorites?Token=\(token)"
    }
    
    static func bookingDetail(token: String, id: String) -> String {
        return "\(baseUrl)/mobile/bookingDetail?Token=\(token)&ID=\(id)"
    }
    
    static func saveReservation(token: String) -> String {
        return "\(baseUrl)/mobile/saveReservation?Token=\(token)"
    }

    static func updateReservation(token: String) -> String {
        return "\(baseUrl)/mobile/updateReservation?Token=\(token)"
    }
    
    static let setParticipants = "/setParticipants"
    
    static func followUser(token: String) -> String {
        return "\(baseUrl)/mobile/followUser?Token=\(token)"
    }
    
    static func getMyFriends(token: String) -> String {
        return "\(baseUrl)/mobile/getMyFriends?Token=\(token)"
    }
    
    static func setReservation(token: String, status: String, meetingPlanId: String, meetingRoomId: String) -> String {
        return "\(baseUrl)/mobile/setReservation?Token=\(token)&status=\(status)&meetingPlanId=\(meetingPlanId)&meetingRoomId=\(meetingRoomId)"
    }
    
    static func extendMeetingPlan(token: String, meetingPlanId: String, minute: Int) -> String {
        return "\(baseUrl)/room/extendMeetingPlan?Token=\(token)&MeetingPlanID=\(meetingPlanId)&Minute=\(minute)"
    }
    
    static func addFavorite(token: String, roomId: Int) -> String {
        return "\(baseUrl)/mobile/addFavorite?Token=\(token)&MeetingRoomID=\(roomId)"
    }
    
    static func removeFromFavorite(token: String, roomId: Int) -> String {
        return "\(baseUrl)/mobile/removeFromFavorite/\(roomId)"
    }
}
