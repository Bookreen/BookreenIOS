import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let locationManager = CLLocationManager()
    private var locationPermissionStatus: CLAuthorizationStatus = .notDetermined
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLocationPermission), name: .ChangedLocationPermission, object: nil)

        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        self.startLocationReceives()
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    @objc func changedLocationPermission() {
        self.startLocationReceives()
    }
    
    private func startLocationReceives() {
        if #available(iOS 14.0, *) {
            let status = self.locationManager.authorizationStatus
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.locationManager.startUpdatingLocation()
            }
        } else {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationPermissionStatus = status
         if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        #if DEBUG
        print("changed location")
        #endif
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        
        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        
        NotificationCenter.default.post(name: .ChangedLocation, object: nil, userInfo: ["latitude": latitude, "longitude": longitude])
    }
}
