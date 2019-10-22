//
//  DatePickerView.swift
//  TabBarApplication
//
//  Created by logesh on 10/18/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Protocol
protocol DatePickerViewDelegate: class {
    func didSaveSelection(datePickerView:DatePickerView, dateText:Date)
    func didCancelSelection()
}

//MARK: CLASS
class DatePickerView: UIView {
    
    //  MARK: - Properties
    private var dateText : Date!
    private var allowFutureDate:Bool = false
    private var dateFormat:String = "MMM-yyyy"
    var delegate:DatePickerViewDelegate?

    //  MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    private   var datePickerflag : Bool = false
    
    //  MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initScreen()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initScreen()
        
    }
    
    //  MARK: - Private Methods
    private func initScreen()
    {
        Bundle.main.loadNibNamed("DatePickerVIew", owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
    }
    
    @IBAction private func datePickerValueChanged(_ sender: Any) {
        self.datePickerflag = true
        self.formatDate()
    }
    
    @IBAction private func cancelSelection(_ sender: Any) {
        self.delegate?.didCancelSelection()
    }
    
    @IBAction private func saveSelection(_ sender: Any) {
                
        if datePickerflag
        {
            self.delegate?.didSaveSelection(datePickerView: self, dateText: dateText)
        }
        else
        {
            self.formatDate()
            self.delegate?.didSaveSelection(datePickerView: self, dateText: dateText)
        }
        
    }
    
    private func formatDate()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        dateText = datePicker.date
    }
    
    //  MARK: - Public Methods
    func initDatePicker(allowFutureDate : Bool, dateFormat:String = "MMM-DD-yyyy")
    {
        let datePickerInstance = datePicker
        self.dateFormat = dateFormat
        datePickerInstance?.datePickerMode = .date
        if allowFutureDate {
            self.datePicker?.minimumDate = NSDate() as Date
        }
        else
        {
            self.datePicker?.maximumDate = NSDate() as Date
        }
    }
    
}
