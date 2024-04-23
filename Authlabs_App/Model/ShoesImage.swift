//
//  ShoesImage.swift
//  Authlabs_App
//
//  Created by Matthew on 4/22/24.
//

import Foundation

enum ShoesImage: String {
    case NikeAirForce0
    case NikeAirForce1
    case NikeAirForce2
    case NikeAirForce3
    case NikeAirForce4
    case NikeAirForce5
    
    var name: String {
        switch self {
        case .NikeAirForce0:
            return "NikeAirForce0"
        case .NikeAirForce1:
            return "NikeAirForce1"
        case .NikeAirForce2:
            return "NikeAirForce2"
        case .NikeAirForce3:
            return "NikeAirForce3"
        case .NikeAirForce4:
            return "NikeAirForce4"
        case .NikeAirForce5:
            return "NikeAirForce5"
        }
    }
    
    var assetLocation: String {
        return "NikeAirForce1.scn"
    }
}
