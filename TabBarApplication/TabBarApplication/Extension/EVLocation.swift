//
//  EventStructData.swift
//  TabBarApplication
//
//  Created by logesh on 10/14/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import CoreLocation



class EVLocation: NSObject,CLLocationManagerDelegate {
    
     var addressManager = CLLocationManager()
    var address  = CurrentAddress()
  
    
    override init() {
        super.init()
    }
    
    func requestLocationAuthorisation(){
           if CLLocationManager.locationServicesEnabled() == true {
               if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                   addressManager.requestWhenInUseAuthorization()
               }
               addressManager.desiredAccuracy = kCLLocationAccuracyBest
               addressManager.delegate = self
               addressManager.requestLocation()
            addressManager.startUpdatingLocation()
            print("123")
           } else {
               print("PLease turn on location services or GPS")
           }
       }
       

    
    
    
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {
      print("IN")
           let userLocation:CLLocation = locations[0]
                  let latitude: CLLocationDegrees = userLocation.coordinate.latitude
                  let longitude: CLLocationDegrees = userLocation.coordinate.longitude
           let location: CLLocation = CLLocation(latitude: latitude,longitude: longitude)
               CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
                   if error != nil
                   {
                       return
                   }
                   if (placemarks?.count)! > 0
                   {
                       let placeMarks = placemarks?[0]
                         self.address.address1 = (placeMarks?.name)!
                         self.address.City = (placeMarks?.locality)!
                        self.address.ZIPCode = (placeMarks?.postalCode)!
                    print("Ifhgh")
                 
                   }
                   else
                   {
                       print("error")
                   }
               })

       }
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
              print("Error")
          }
    
    
    func getAddress() -> CurrentAddress {
        addressManager.startUpdatingLocation()
        requestLocationAuthorisation()
        print(address)
        return address
    }
    
}
