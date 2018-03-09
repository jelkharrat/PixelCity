//
//  MapVC.swift
//  pixel-city
//
//  Created by Nessin Elkharrat on 3/8/18.
//  Copyright © 2018 practice. All rights reserved.


//Installing cocopod: go to pixel-city directory and just put in "pod init" if you have it. If not put in "sudo gem install cocoapods" then pod init
//Need to install alamofire and alamofireimage from github
//Need to go into pods file/build settings, then switch version to 3.2



import UIKit
import Alamofire
import MapKit


class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    @IBAction func centerMapButtonWasPressed(_ sender: Any) {
    }
}

//Need to conform to MapViewDelegate
extension MapVC: MKMapViewDelegate {
    
}

