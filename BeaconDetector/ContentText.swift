//
//  ContentText.swift
//  BeaconDetector
//
//  Created by 竹ノ内愛斗 on 2020/12/21.
//

import Foundation
// ここにCoreLocationを持つのはいけてない、、
import CoreLocation

struct ContentText {

    var clProximity: CLProximity

    func getText() -> String {
        switch clProximity {
        case .immediate:
            return "RIGHT HERE"
        case .near:
            return "NEAR"
        case .far:
            return "FAR"
        case .unknown:
            return "iBeacon Detector"
        @unknown default:
            fatalError("Unknown cases")
        }
    }
}
