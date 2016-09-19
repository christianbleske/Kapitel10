//
//  ViewController.swift
//  PositionsdiensteBsp
//
//  Created by Christian Bleske on 24.02.15.
//  Copyright (c) 2015 Christian Bleske. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let clLocationManager = CLLocationManager()
    
    @IBOutlet weak var laLocality: UILabel!
    @IBOutlet weak var laPostalCode: UILabel!    
    @IBOutlet weak var laCountry: UILabel!
    @IBOutlet weak var laArea: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func btnGetPosition_Pressed(_ sender: AnyObject) {
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ locManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(locManager.location!, completionHandler: {(placemarks, error)->Void in
        
            if (error != nil) {
                print("Fehler bei der Umwandlung der Geokoordinaten: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let clPlacemark = placemarks?.first //placemarks[0] as! CLPlacemark
                self.setLocationInformation(clPlacemark)
            } else {
                print("Fehlerhafte Daten vom Geocoder")
            }
        })
    }
    
    func setLocationInformation(_ clPlacemark: CLPlacemark?) {
        if let placemark = clPlacemark {
            
            //Aktualisierung des Geodienstes stoppen -> Batterie sparen...
            clLocationManager.stopUpdatingLocation()
            
            laLocality.text = (placemark.locality != nil) ? placemark.locality : ""
            laPostalCode.text = (placemark.postalCode != nil) ? placemark.postalCode : ""
            laArea.text = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
            laCountry.text = (placemark.country != nil) ? placemark.country : ""
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fehler bei der Aktualisierung der Position: " + error.localizedDescription)
    }


}

