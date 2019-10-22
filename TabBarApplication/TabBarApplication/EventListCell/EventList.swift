//
//  EventList.swift
//  TabBarApplication
//
//  Created by logesh on 10/18/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import UIKit

class EventList: UITableViewCell {
    
    
    @IBOutlet weak var eventImage: UIImageView?
    @IBOutlet weak var eventTitle: UILabel?
    @IBOutlet weak var eventDate: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
     //   self.layer.insertSublayer(gradient(frame: self.bounds), at:0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    
    
    func setupView()  {
        eventDate?.textColor = UIColor.gray
        eventImage!.layer.borderWidth = 1.0
        eventImage!.layer.masksToBounds = false
        eventImage!.layer.borderColor = UIColor.green.cgColor
        eventImage!.layer.cornerRadius = eventImage!.frame.size.width/2
        eventImage!.clipsToBounds = true
        eventImage!.isUserInteractionEnabled = true
        
    }
    
    func setupCell(eventTitle : String , eventDate : String , eventImage : UIImage){
        self.eventTitle?.text = eventTitle
        self.eventDate?.text = eventDate
        self.eventImage?.image = eventImage
    }
    
    
    
    
}
