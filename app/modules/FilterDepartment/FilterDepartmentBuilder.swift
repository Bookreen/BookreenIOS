import Foundation
import UIKit


final class FilterDepartmentBuilder {
    
    private init() {}
    
    static func make() -> FilterDepartmentViewController {
        let storyboard = UIStoryboard(name: "FilterDepartment", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterDepartmentViewController") as! FilterDepartmentViewController
        return viewController
    }
}
