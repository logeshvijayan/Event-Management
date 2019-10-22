//
//  EVStructFile.swift
//  TabBarApplication
//
//  Created by logesh on 10/14/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import UIKit

struct CurrentAddress  {
    var address1 : String
    var address2 : String
    var City : String
    var province : String
    var ZIPCode : String
    
    
    init() {
        address1 = " "
        address2 = " "
        City = " "
        province = " "
        ZIPCode =  ""
    }
}

struct EventDetails {
    var eventName : String!
    var eventDate : Date!
    var eventDescription : String!
    var eventImage : UIImage?
}
enum section: Int {
    
    case Allevents = 1
    case Intrested = 2
    case NotIntrested = 3
}
