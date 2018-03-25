//
//  Constants.swift
//  pixel-city
//
//  Created by Nessin Elkharrat on 3/25/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation

let apiKey = "27a6eb19d989b17a38eb4dc7ec643e72"

func flickrURL(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}

