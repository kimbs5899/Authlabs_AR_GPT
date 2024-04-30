//
//  ShoesImage.swift
//  Authlabs_App
//
//  Created by Matthew on 4/22/24.
//

import Foundation

enum AssetsImage: String {
    case nikeAirForce0
    case nikeAirForce1
    case nikeAirForce2
    case nikeAirForce3
    case nikeAirForce4
    case nikeAirForce5
    case starbucks
    case qrcode
    
    var name: String {
        switch self {
        case .nikeAirForce0:
            return "nikeAirForce0"
        case .nikeAirForce1:
            return "nikeAirForce1"
        case .nikeAirForce2:
            return "nikeAirForce2"
        case .nikeAirForce3:
            return "nikeAirForce3"
        case .nikeAirForce4:
            return "nikeAirForce4"
        case .nikeAirForce5:
            return "nikeAirForce5"
        case .starbucks:
            return "starbucks"
        case .qrcode:
            return "qrcode"
        }
    }
    
    var assetLocation: String {
        return "NikeAirForce1.scn"
    }
}
