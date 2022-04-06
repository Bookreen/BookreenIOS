import Foundation
import UIKit

public extension Notification.Name {
    static let showLoadingView = Notification.Name("showLoadingView")
    static let dismissLoadingView = Notification.Name("dismissLoadingView")
    static let didChangeFilterOffice = Notification.Name("didChangeFilterOffice")
    static let didChangeSelectedOffice = Notification.Name("didChangeSelectedOffice")
    static let didChangeTab = Notification.Name("didChangeTab")
    static let ChangedLocationPermission = Notification.Name("ChangedLocationPermission")
    static let ChangedLocation = Notification.Name("ChangedLocation")
}
