//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Deniz Tutuncu on 1/28/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        alarmIsOn = alarm.enable
        alarmDatePicker.date = alarm.fireDate
        alarmTextField.text = alarm.name
        
    }
    
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var alarmButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.delegate = self 
        
    }
    
    func setUpAlarmButton(){
        
        switch alarmIsOn {
        case true:
            alarmButton.backgroundColor = UIColor.blue
            alarmButton.setTitle("ON", for: .normal)
        case false:
            alarmButton.backgroundColor = UIColor.gray
            alarmButton.setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func alarmButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.shared.toggleEnaled(for: alarm)
            alarmIsOn = alarm.enable
        }else{
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = alarmTextField.text, title != "" else { return }
        
        if let alarm = alarm {
            AlarmController.shared.updateAlarm(alarm: alarm, fireDate: alarmDatePicker.date, name: title, enable: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: alarmDatePicker.date, name: title, enable: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }

}
