//
//  EventListViewController.swift
//  TabBarApplication
//
//  Created by logesh on 10/18/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {

    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationBar!
    var eventListArray : [String] = []
    var eventSubtitle : [String] = []
    var Section : [String] = ["ALL Eevents","Favourites","Not Interested"]
  //  let dataModel : EventData = EventData()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavigationTitle()
        self.loadeventList()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadeventList()
        eventTableView.reloadData()
    }
    
    
    
    func setupTableView(){
         eventTableView.register(UINib.init(nibName: "EventList", bundle: nil), forCellReuseIdentifier: "EventListCell")
        eventTableView.delegate = self
        eventTableView.dataSource = self
     
        
    }
    
    func setupNavigationTitle()  {
        self.navigationTitle.topItem?.title = "Events"
        self.navigationTitle.backgroundColor = UIColor.white
    }
    
    func loadeventList()
    {
        eventListArray = []
        eventSubtitle=[]
        let events = EventData.shared.readData()
       for event in events
       {
        eventListArray.append(event.eventName!)
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMM-dd-yyyy,HH:mm"
        dateFormatter.string(from: event.eventDate!)
        eventSubtitle.append(dateFormatter.string(from: event.eventDate!))
        }
    }

}

extension EventListViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventList
        dataCell.setupCell(eventTitle: eventListArray[indexPath.row], eventDate: eventSubtitle[indexPath.row], eventImage: UIImage(named: "IronMan")!)
        return dataCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
        EventData.shared.deleteEventdata(eventName: self.eventListArray[indexPath.row])
        self.eventListArray.remove(at: indexPath.row)
        self.eventSubtitle.remove(at: indexPath.row)
       
        tableView.reloadData()
                           }
                    delete.backgroundColor = UIColor.red
                    delete.image = UIImage(systemName: "trash")
        
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            EventData.shared.editEventdata(eventName: self.eventListArray[indexPath.row])
                                  }
               edit.backgroundColor = UIColor.systemBlue
               edit.image = UIImage(systemName: "compose")
        
        
        
        let config = UISwipeActionsConfiguration(actions: [delete,edit])
                          config.performsFirstActionWithFullSwipe = true
                          return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let intrested = UIContextualAction(style: .normal, title: "Intrested") { (action, view, nil) in
                         print("Accept")
                     }
              intrested.backgroundColor = UIColor.green
             intrested.image = UIImage(named: "Heart")
              
              let notIntrested = UIContextualAction(style: .normal, title: "Not Interested") { (action, view, nil) in
                         print("Waitlist")
                     }
              notIntrested.backgroundColor = UIColor.red
        notIntrested.image = UIImage(named: "Dislike")
              let config = UISwipeActionsConfiguration(actions: [intrested, notIntrested])
                     config.performsFirstActionWithFullSwipe = false
                     return config
    }
    
    
    
    
    
    
    
}


