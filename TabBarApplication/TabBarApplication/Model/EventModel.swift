//
//  EventModel.swift
//  TabBarApplication
//
//  Created by logesh on 10/18/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import UIKit


class EventModel: NSObject,EventsControllerdeleagte {
    
    
    let eventsController  = EventsController()
    
    override init() {
        super.init()
        eventsController.delegate = self
    }

    
    func saveEvent(eventData: EventDetails, addressData: CurrentAddress) {
        print(eventData)
        print(addressData)
    }
    

    
    
    
}
