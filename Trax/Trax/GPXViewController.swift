//
//  ViewController.swift
//  Trax
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet{
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    var gpxURL: NSURL? {
        didSet{
            if let url = gpxURL{
                
            }
        }
    }
    
    private func clearWayPoints(){
        if mapView?.annotations {
            mapView.removeAnnotation(mapView.annotations as [MKAnnotation])
        }
    }
    
    private func handleWaypoints(){
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelete = UIApplication.sharedApplication()
        
        center.addObserverForName(GPXURL.notification, object: appDelete, queue: queue){
            notification in
            if let url = notification?.userInfo?[GPXURL.key] as? NSURL{
                
            }
        }
    }


}

