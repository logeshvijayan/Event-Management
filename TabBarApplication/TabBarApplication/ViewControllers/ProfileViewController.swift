//
//  ProfileViewController.swift
//  TabBarApplication
//
//  Created by logesh on 10/11/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import Photos
import UIKit
import CoreLocation




//MARK: - Class
class ProfileViewControlller : UIViewController,CLLocationManagerDelegate{
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var gpsSwitch: UISwitch!
    var locationManager = CLLocationManager()
    let Defaults = UserDefaults.standard
    var address : CurrentAddress = CurrentAddress()
    @IBAction func gpsSwitch(_ sender: UISwitch) {
        if gpsSwitch.isOn
        {
            locationManager.startUpdatingLocation()
         requestLocationAuthorisation()
        }
        else
        {
            locationManager.stopUpdatingLocation()
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       setupTextField()
       setProfilePictureView()
       setupSwitch()
       
    }
    
    
    //MARK: - View Functions
    func setProfilePictureView()  {
        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.blue.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
     profileImage.addGestureRecognizer(tapGestureRecognizer)
        guard let imageData = Defaults.value(forKey: profileName.text ?? "ProfieName")  else {
            return
        }
        profileImage.image = UIImage(data: imageData as! Data)!
        
    }
    
    func setupTextField()  {
        
        
        profileName.text = UIDevice.current.name
        profileName.textAlignment = .center
    }
    
    func setupSwitch(){
        gpsSwitch.isOn = false
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.imagePicker()
    }
    
    //MARK: - Core Location Functionality
    func requestLocationAuthorisation(){
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            print("2 In")
            locationManager.requestLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

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
               //     print(self.address)
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
    func getCurrentAddress()-> CurrentAddress
    {
       print("Here in")
        requestLocationAuthorisation()
        return address
    }
    
    
    
}

//MARK: - Album Functionality Extension
extension ProfileViewControlller : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    fileprivate func presentPhotoPickerController() {
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[.editedImage] as? UIImage {
            Defaults.set(image.jpegData(compressionQuality: 100),forKey: profileName.text!)
             self.profileImage.image = image
              } else if let image = info[.originalImage] as? UIImage {
                Defaults.set(image.jpegData(compressionQuality: 100),forKey: profileName.text!)
                  self.profileImage.image = image
              }
              dismiss(animated: true)
    }

    func imagePicker()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.presentPhotoPickerController()
            case .notDetermined:
                if status == PHAuthorizationStatus.authorized {
                    self.presentPhotoPickerController()
                }
            case .restricted:
                print("Restricted")
                let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo Library access is restricted and cannot be accessed.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            case .denied:
                print("Denied")
                let alert = UIAlertController(title: "Photo Library Access Denied", message: "Photo Library access was previously denied. Please update your Settings if you wish to change this.", preferredStyle: .alert)
                let gotoSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
                    DispatchQueue.main.async {
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        UIApplication.shared.open(url, options: [:])
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(gotoSettingsAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            @unknown default:
                fatalError()
            }
        }
    }
}

