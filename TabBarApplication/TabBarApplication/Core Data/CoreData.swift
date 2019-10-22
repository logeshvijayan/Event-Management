//
//  CoreData.swift
//  TabBarApplication
//
//  Created by logesh on 10/12/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import CoreData


//MARK: - Class
class EventData: NSObject {
 
    static let shared = EventData()
   
    var eventTempdata : [Event] = [ ]

    var context:NSManagedObjectContext {
          return self.container.viewContext
      }
    
    
    private var container: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EventModel")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContainer
    }()
    
   
    
    
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func readData() -> [Event] {
        
        let context = container.viewContext
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        do{
          eventTempdata = try context.fetch(request)
           
        }
        catch{
            print(error)
        }
        
         return eventTempdata
    }
    
    func saveEventdata(eventData : EventDetails , eventAddress : CurrentAddress)  {
        let eventContext = Event(context: container.viewContext) 
        eventContext.eventName = eventData.eventName
       // eventContext.eventImage = eventData.eventImage
        eventContext.eventDescription = eventData.eventDescription
        eventContext.eventAddress1 = eventAddress.address1
        eventContext.eventAddress2 = eventAddress.address2
        eventContext.eventPostalCode = eventAddress.ZIPCode
        eventContext.eventDate = eventData.eventDate
        self.saveContext()
    }
    
    func editEventdata(eventName : String)-> Event  {
        let eventList = readData()
        var  eventObject : Event = Event()
        for event in eventList
        {
            if event.eventName == eventName
            {
                eventObject =  event
                print(event.eventName)
            }
        }
        return eventObject
    }
    
    
    func deleteEventdata(eventName : String) {
        let eventContext = Event(context: container.viewContext)
        let eventObject = editEventdata(eventName: eventName)
        container.viewContext.delete(eventObject)
        self.saveContext()
    }
  
    
    
}


