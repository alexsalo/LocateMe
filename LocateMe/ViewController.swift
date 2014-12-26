//
//  ViewController.swift
//  LocateMe
//
//  Created by Aleksandr Salo on 12/25/14.
//  Copyright (c) 2014 Aleksandr Salo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet var label_latitude: UILabel!
    @IBOutlet var label_longitude: UILabel!
    @IBOutlet var label_altitude: UILabel!
    @IBOutlet var label_accuracy: UILabel!
    @IBOutlet var label_speed: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var historicalPoints = [CLLocationCoordinate2D]()
    var routeTrack = MKPolyline()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(String(format: "a float number: %.2f", 1.0321))
        locationManager.delegate = self
        locationManager.desiredAccuracy = 20
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
    }
    
//Location Manager Delegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            // Update the fields as expected:
            label_latitude.text = String(format:"%.2f",location.coordinate.latitude)
            label_longitude.text = String(format:"%.2f",location.coordinate.longitude)
            label_altitude.text = String(format:"%.2f m",location.altitude)
            label_accuracy.text = String(format:"%.2f m",location.horizontalAccuracy)
            label_speed.text = String(format:"%.2f ms⁻¹",location.speed)
            // Re-center the map
            mapView.centerCoordinate = location.coordinate
            // And update the track on the map
            historicalPoints.append(location.coordinate)
            updateMapWithPoints(historicalPoints)
        }
    }
    
    private func updateMapWithPoints(points: [CLLocationCoordinate2D]) {
        let oldTrack = routeTrack
        
        // This has to be mutable, so we make a new reference
        var coordinates = points
        
        // Create the new route track
        routeTrack = MKPolyline(coordinates: &coordinates, count: points.count)
        
        // Switch them out
        mapView.addOverlay(routeTrack)
        mapView.removeOverlay(oldTrack)
        
        // Zoom the map
        mapView.visibleMapRect = mapView.mapRectThatFits(routeTrack.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
//MKMapViewDelegate Methods
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if let overlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay)
            renderer.lineWidth = 4.0
            renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            return renderer
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


