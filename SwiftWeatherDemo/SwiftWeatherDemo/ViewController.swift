//
//  ViewController.swift
//  SwiftWeatherDemo
//
//  Created by Binea Xu on 15/3/1.
//  Copyright (c) 2015年 Binea Xu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if(ios8()){
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ios8()->Bool{
        println(UIDevice.currentDevice().systemVersion)
        return UIDevice.currentDevice().systemVersion == "8.1"
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location : CLLocation = locations[locations.count - 1] as CLLocation
        if location.horizontalAccuracy > 0 {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
            
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    }
    
    func updateWeatherInfo(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let manager = AFHTTPRequestOperationManager()
        
        let url = ""
        
        let params = ["lat": latitude, "lon": longitude, "cnt": 0]
        
        
    }

}

