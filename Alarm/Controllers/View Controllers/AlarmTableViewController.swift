//
//  AlarmTableViewController.swift
//  Alarm
//
//  Created by Deniz Tutuncu on 1/28/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmTableViewController: UITableViewController, AlarmScheduler {

    override func viewDidLoad() {
        super.viewDidLoad()

        //AlarmController.shared.alarms = AlarmController.shared.mockAlarms
        tableView.delegate = self
        tableView.dataSource = self
        AlarmController.shared.delegate = self 
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        return cell
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.deleteAlarm(alarm: alarm)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCellToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
                let alarmToSend = AlarmController.shared.alarms[indexPath.row]
                destinationVC.alarm = alarmToSend
            }
        }
    }
 

}
//Step 4 for Custom Delegate
extension AlarmTableViewController: SwitchTableViewCellDelegate {
   
    
    func switchValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm,
            let cellIndexPath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        alarm.enable = selected
        tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    
}

