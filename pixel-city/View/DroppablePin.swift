//
//  DroppablePin.swift
//  pixel-city
//
//  Created by Nessin Elkharrat on 3/16/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier:String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
