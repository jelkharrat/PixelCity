//https://www.flickr.com/services/developer/api/
//go to non commercial services
//get an API KEY
//https://www.flickr.com/services/api/explore/flickr.photos.search
//allows you to pass in a lat a long and radius and it will return photos from there
//take UR from bottom (allow 40 per page)

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
import CoreLocation



class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    
    //Variables
    var locationManager = CLLocationManager()
    var spinner:UIActivityIndicatorView?
    var progressLbl: UILabel?
    var screenSize = UIScreen.main.bounds
    
    //when instantiating a collection view programmatically, you need a glow layout
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    
    //Constants
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000 //meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        //need to go to info.plist + button and add "privacy - location always..." and "privacy -  when in use..." and "NSLocationAlwaysandWhenInUseUsaageDescription" and add descriptions of how app is using location 
        configureLocationServices()
        addDoubleTap()
        
        //instantiate collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        
        //registering a cell to use. Need a cell class. Create one in the View Folder
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        
        //creating another extension for these at the bottom
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        //checks if it actually comes up
        collectionView?.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        pullUpView.addSubview(collectionView!)
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        //UITapGestureRecognizer function will be located in MKMapViewDelegate
        
        doubleTap.numberOfTapsRequired = 2
        
        //Need to conform uitapgesturerecognizer delegate. Need to inherit
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    //swipe the mapview down to hide the table
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        //modifying the constraint to make it move up
        pullUpViewHeightConstraint.constant = 300
   
        UIView.animate(withDuration: 0.3) {
            //part of the view. lays out subviews immediately. redraw and show whats changed
            self.view.layoutIfNeeded()
        }
    }
    
    //action for UISwipeGestureRecognizer in func animateViewUp()
    @objc func animateViewDown() {
        pullUpViewHeightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            //part of the view. lays out subviews immediately. redraw and show whats changed
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil{
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        progressLbl?.textAlignment = .center
       // progressLbl?.text = "Always 12"

        collectionView?.addSubview(progressLbl!)
    }
    
    func removeProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }

    @IBAction func centerMapButtonWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
}

//Need to conform to MapViewDelegate
extension MapVC: MKMapViewDelegate {
    //changing color of pin to match project theme
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Prevents automatic pin drop of current location
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppblePin")
        pinAnnotation.pinTintColor = UIColor.orange
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    //This function zooms the map into the location of the user for a better view
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        //its one way so need to multiply to get both ways
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin()
        removeProgressLbl()
        removeSpinner()

        animateViewUp()
        //adds the ability to swipe once there is a pin dropped
        addSwipe()
        
        addSpinner()
        
        
        addProgressLbl()
        
        //print("doubleTap is working")
        
        //going to create a touchpoint which shows on the map where user touched the exact coordinates ON THE SCREEN (not geolocation) of that spot
         let touchPoint = sender.location(in: mapView)
        
        //print(touchPoint)
        
        //this takes the CGPoint and converts it into a geolocation coordinate
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        //Want to pass coordinates into a pin on the map (need a class of MK annotation)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        
        mapView.addAnnotation(annotation)
        
       // print(flickrURL(forApiKey: apiKey, withAnnotation: annotation, andNumberOfPhotos: 40))

        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //func to remove pins not being used
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    
}

extension MapVC: CLLocationManagerDelegate {
    //Checks to see if app is authorized to use location services
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            //going to request authorization always whether the app is open or not
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    //this function gets called any time map view authorization status is changed, so if wheninuselocationservices is approved, it will center on the user
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}



extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "photoCell", for: indexPath) as? PhotoCell
        
        return cell!
    }
}
