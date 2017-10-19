//
//  MapViewExtension.swift
//  geoMessenger
//
//  Created by Andrew Webber on 10/18/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import MapKit

//class MapViewExtension: NSObject, MKMapViewDelegate{

extension FirstViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Message{
            let identifier = "Pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x:-8,y:-5)
                view.pinTintColor = .green
                view.animatesDrop = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let message = view.annotation as! Message
        let placeName = message.title
        let placeInfo = message.subtitle
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        ac.addAction(UIAlertAction(title: "remove", style: .default) {
            (result : UIAlertAction)->Void in
            mapView.removeAnnotation(message)
        })
        
        present(ac, animated: true)
    }
    
//    func viewDidLoad() {
//        super.viewDidLoad()
//        let initialLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
//        centerMapOnLocation(location: initialLocation)
//        
//        mapView.delegate = self
//        
//        let message = Message(title: "Bucks in 6!", locationName: "Bradley Center", username: "John Smith", coordinate: CLLocationCoordinate2D(latitude: 43.043914, longitude: -87.917262), isDisabled: true)
//        mapView.addAnnotation(message)
//        
//    }
    
}
