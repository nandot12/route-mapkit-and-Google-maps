//
//  FirstViewController.swift
//  Map route sample
//
//  Created by Nando Septian Husni on 22/08/18.
//  Copyright © 2018 IMASTUDIO. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController,CLLocationManagerDelegate {
    
    let coordinat  = CLLocationManager()
    
    var mapView : GMSMapView?
    var lat : Double?
    var lon : Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinat.delegate = self
        coordinat.requestLocation()
        coordinat.requestAlwaysAuthorization()
        
        
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
       
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinat = locations.last?.coordinate
        lat = coordinat?.latitude
        lon = coordinat?.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        marker.title = "title"
        marker.snippet = "lokasi ku "
        marker.map = mapView
        
        route()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func route(){
        
        let posisi1 = String(lat!) + "," + String(lon!)
        let posisi2 = "-6.1935488,106.7887633"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + posisi1 + "&destination=" + posisi2
        
        print(url)
        
        Alamofire.request(url).responseJSON { (json) in
            
            let json2 = JSON(json.result.value as Any)
            let route = json2["routes"].arrayValue
            let poli = route[0]["overview_polyline"].dictionaryValue
            
            let point = poli["points"]?.stringValue
            
            let path = GMSPath(fromEncodedPath: point!)
            let polyi = GMSPolyline(path: path)
            
            polyi.strokeColor  = UIColor.black
            polyi.strokeWidth =   5
            polyi.map = self.mapView
            
            
            
        }
        
    }


}

