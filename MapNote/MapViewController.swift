//
//  ViewController.swift
//  MapNote
//
//  Created by Kyle Brooks Robinson on 7/29/16.
//  Copyright © 2016 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MyAnnotation: MKPointAnnotation {
    var venueIndex: Int!
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let initialLocation = CLLocation(latitude: 33.8651, longitude: 84.3366)
    let regionRadius: CLLocationDistance = 1000
    
    var locationManager = CLLocationManager()
    
    var myVenues: [[String:AnyObject]] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        mapView.delegate = self
        
        locationManager.startUpdatingLocation()

        centerMap(initialLocation)
        
    }
    
    func centerMap(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        print("Latitude \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
        
        requestVenuesWithLocation(location) { (venues) in
            
            self.myVenues = venues as! [[String:AnyObject]]
            
            for (index, venue) in self.myVenues.enumerate() {
                
                guard let locationInfo = venue["location"] as? [String:AnyObject] else { return }
                
                guard let latitude = locationInfo["latitude"] as? Double else { return }
                guard let longitude = locationInfo["longitude"] as? Double else { return }
                
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                
                let annotation = MyAnnotation()
                annotation.title = venue["name"] as? String
                annotation.venueIndex = index
                annotation.coordinate = coordinate
                
                self.mapView.addAnnotation(annotation)
                
            }
            
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }

    func requestVenuesWithLocation(location: CLLocation, completion: (venues: [AnyObject]) -> Void) {
        
        let endpoint = API_URL + "venues/search?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)&v=20150101"
        
        print("Endpoint: \(endpoint)")
        
        guard let url = NSURL(string: endpoint) else { return }
        
        let request = NSURLRequest(URL: url)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            do {
                
                let returnedInfo = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String: AnyObject]
                
                guard let responseInfo = returnedInfo!["response"] as? [String:AnyObject] else { return }
                
                guard let venuesInfo = responseInfo["venues"] as? [AnyObject] else { return }
                
                completion(venues: venuesInfo)
                
            } catch let error as NSError {
                
                print(error)
                
            }
            
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKUserLocation else { return nil }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        
        annotationView.pinColor = MKPinAnnotationColor.Purple
        annotationView.canShowCallout = true
        
        let button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
        annotationView.rightCalloutAccessoryView = button
        
        button.tag = (annotation as! MyAnnotation).venueIndex
        
        button.addTarget(self, action: Selector("showNoteView:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return annotationView
        
        
    }
    
    func showNoteView(sender: UIButton) {
        
        var noteVC = storyboard?.instantiateViewControllerWithIdentifier("noteVC") as! NoteTableViewController
        
        var venue = myVenues[sender.tag]
        print("Venue: \(venue)")
        
//        noteVC.view.backgroundColor = UIColor.whiteColor()
        
        if let stats = venue["stats"] as? [String:AnyObject] {
            
            let checkInCount = stats["checkinsCount"] as! Int
            let usersCount = stats["usersCount"] as! Int
            let tipCount = stats["tipCount"] as! Int
            let name = venue["name"] as! String
            
//            noteVC.checkingCircle.setTitle("\(checkInCount)", forState: UIControlState.Normal)
//            noteVC.usersCircle.setTitle("\(usersCount)", forState: UIControlState.Normal)
//            noteVC.tipsCircle.setTitle("\(tipCount)", forState: UIControlState.Normal)
            
        }
        
        guard let categories = venue["categories"] as? [AnyObject] else { return }
            
        let insideCategories = categories[0] as! [String:AnyObject]
            
        print("INSIDE!! CATEGORIES!!")
        print(insideCategories)
            
        guard let icon = insideCategories["icon"] as? [String:AnyObject] else { return }
        
        let prefix = icon["prefix"] as! String
        let suffix = icon["suffix"] as! String
                
        let fullLink = prefix + suffix
                
        guard let imageURL = NSURL(string: fullLink) else { return }
                    
        print("imageURL: \(imageURL)")
                    
        guard let data = NSData(contentsOfURL: imageURL) else { return }
                        
        let image = UIImage(data: data)
//        noteVC.iconView.image = image
        
    }
    
    
}



















