//
//  DisplaySettings.swift
//  Bookreen
//
//  Created by bullhead on 12/10/21.
//

import Foundation
struct DisplaySettings : Decodable{
    enum CodingKeys : String,CodingKey{
        case qrCheckin="QrCheckin"
    }
    let qrCheckin:String?
}
