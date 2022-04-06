import Foundation
import UIKit

public class ColorPalette {
    
    public static let shared = ColorPalette()
    
    private init() {}
    
    public let colorWhite: UIColor = "#ffffff".hexStringToUIColor()
    
    public let colorBlueGrey100: UIColor = "#cfd8dc".hexStringToUIColor()
    public let colorBlueGrey700: UIColor = "#455a64".hexStringToUIColor()
    public let colorBlack: UIColor = "#000000".hexStringToUIColor()
    public let colorGrey100: UIColor = "#f5f5f5".hexStringToUIColor()
    public let colorGrey200: UIColor = "#eeeeee".hexStringToUIColor()
    public let colorGrey300: UIColor = "#e0e0e0".hexStringToUIColor()
    public let colorGrey400: UIColor = "#bdbdbd".hexStringToUIColor()
    public let colorGrey500: UIColor = "#9e9e9e".hexStringToUIColor()
    public let colorGrey600: UIColor = "#eeeeee".hexStringToUIColor()
    public let colorGrey700: UIColor = "#757575".hexStringToUIColor()
    public let colorGrey800: UIColor = "#424242".hexStringToUIColor()
    public let colorGrey900: UIColor = "#212121".hexStringToUIColor()

    public let colorDarkPurple800: UIColor = "#38006b".hexStringToUIColor()
    public let colorPurple100: UIColor = "#e1bee7".hexStringToUIColor()
    public let colorPurple050: UIColor = "#f3e5f5".hexStringToUIColor()
    public let colorRed500: UIColor = "#f44336".hexStringToUIColor()
    
    public let colorGreen: UIColor = "#4caf50".hexStringToUIColor()
    
    public let colorBlue: UIColor = "#2196f3".hexStringToUIColor()
    
    public let colorCyan400Light: UIColor = "#6ff9ff".hexStringToUIColor()
    
    public let colorOrange500: UIColor = "#ff9800".hexStringToUIColor()
    
    let accentColor=UIColor.init(named: "AccentColor")!
}
