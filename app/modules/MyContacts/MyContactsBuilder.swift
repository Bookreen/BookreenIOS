import Foundation
import UIKit

final class MyContactsBuilder {
    
    private init() {
        
    }
    
    static func make() -> MyContactsViewController {
        let storyboard = UIStoryboard(name: "MyContacts", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyContactsViewController") as! MyContactsViewController
        return viewController
    }
}
