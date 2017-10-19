//
//  FirstViewController.swift
//  geoMessenger
//
//  Created by Andrew Webber on 10/18/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FirstViewController: UIViewController {

    var messageNodeRef: DatabaseReference!
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 43.039616, longitude: -87.930688)
        centerMapOnLocation(location: initialLocation)

        //firebase
        messageNodeRef = Database.database().reference().child("messages")
        let pinMessageId = "msg-1"
        var pinMessage: Message?
        messageNodeRef.child(pinMessageId).observe(.value, with: { (snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any]
            {
                if pinMessage != nil{
                    self.mapView.removeAnnotation(pinMessage!)
                }
                let pinLat = dictionary["latitude"] as! Double
                let pinLong = dictionary["longitude"] as! Double
                let messageDisabled = dictionary["isDisabled"] as! Bool
                
                let message = Message(title: (dictionary["title"] as? String)!, locationName: (dictionary["locationName"] as? String)!, username: (dictionary["username"] as? String)!, coordinate: CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong), isDisabled: messageDisabled)
                pinMessage = message
                
                if !message.isDisabled{
                    self.mapView.addAnnotation(message)
                }
            }
        })
        
//        let message = Message(title: "Bucks in 6!", locationName: "BMO Harris Bradley Center", username: "John Smith", coordinate: CLLocationCoordinate2D(latitude: 43.043914, longitude: -87.917262), isDisabled: false)
//        mapView.addAnnotation(message)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //mark on map
    let locationManager = CLLocationManager()
    func checkLocationAuthorizedStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizedStatus()
    }
    
    

}

