//
//  Events.swift
//  TabBarApplication
//
//  Created by logesh on 10/11/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import UIKit


protocol EventsControllerdeleagte  {
    func saveEvent(eventData : EventDetails , addressData : CurrentAddress )
}



//MARK: - Class
class EventsController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventAddress1: UITextField!
    @IBOutlet weak var eventAddress2: UITextField!
    @IBOutlet weak var eventCity: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
  //  let coreData : EventData = EventData.shared
    var delegate : EventsControllerdeleagte?
    var event:EventDetails = EventDetails()
    var eventAddress:CurrentAddress = CurrentAddress()
    
    //MARK: - Action
    @IBAction func saveButton(_ sender: Any) {
        saveEventData()
    }
    @IBAction func cancelButton(_ sender: Any) {
     let textFd = getAllTextFields(fromView: self.view)
        textFd.map{($0.text = " ")}
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.flatMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func getLocation(_ sender: Any) {
        let eventLocation  = EVLocation()
       let eventAddress =  eventLocation.getAddress()
        print("Achieved",eventAddress)
    }
    
    @IBAction func eventDate(_ sender: Any) {
        self.setSubView()
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupImageView()
    }
    

    //MARK: - Functions
    
    func setupView()  {
        self.navigationBar.topItem?.title = "Create Events"

    }
    
    func setupImageView()  {
        eventImage!.layer.borderWidth = 1.0
             eventImage.layer.masksToBounds = false
             eventImage!.layer.borderColor = UIColor.blue.cgColor
             eventImage!.layer.cornerRadius = eventImage!.frame.size.width/2
             eventImage!.clipsToBounds = true
             eventImage!.isUserInteractionEnabled = true
    }
    
    
    func saveEventData()
    {
        event.eventName = self.eventName.text
        event.eventImage = UIImage(named: "IronMan")
        event.eventDescription = self.eventDescription.text!
        eventAddress.address1 = self.eventAddress1.text!
        eventAddress.address2 = self.eventAddress1.text ?? " "
        eventAddress.City = self.eventCity.text!
        eventAddress.province = "ON"
        eventAddress.ZIPCode = self.postalCode.text!
        EventData.shared.saveEventdata(eventData: event, eventAddress: eventAddress)
    }
    
    func setSubView()
    {
        let subViewFrame : CGRect = CGRect(x: 0,y: 552,width: 414,height: 260)
                               let testView : DatePickerView = DatePickerView(frame: subViewFrame)
                               testView.delegate = self
                               testView.tag = 100
                               self.view.addSubview(testView)
    }
    
    
    
    
}

//MARK: - Text Field Extension
extension EventsController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == eventDate {
            self.view.endEditing(true)
             textField.resignFirstResponder()
            self.setSubView()
            
               }
    }
    
}

//MARK: - DatePicker Functions
extension EventsController : DatePickerViewDelegate {
    
    func didSaveSelection(datePickerView: DatePickerView, dateText: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        self.eventDate.text = dateFormatter.string(from: dateText)
         event.eventDate = dateText
    }
    
    func didCancelSelection() {
        if let viewWithTag = self.view.viewWithTag(100) {
           viewWithTag.removeFromSuperview()
       }else{
           print("No!")
       }
    }
    
     
 }
 
