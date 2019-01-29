//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Deniz Tutuncu on 1/28/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import UIKit

//Step 1 for Custom delegate
protocol SwitchTableViewCellDelegate: class {
    func switchValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    //Step 2 for Custom delegate
    weak var delegate: SwitchTableViewCellDelegate?
    
    func updateViews() {
        guard let alarm = alarm else { return }
        
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enable
        
        backgroundColor = alarm.enable ? .yellow : .white
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
  
    //Step 3 for Custom Delegate
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(self, selected: alarmSwitch.isOn)
    }
    

}
