//
//  AlarmController.swift
//  Alarm
//
//  Created by Deniz Tutuncu on 1/28/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}


extension AlarmScheduler{
    
    func scheduleUserNotification(for alarm: Alarm){
        
        let content = UNMutableNotificationContent()
        content.title = "Time to get up"
        content.body = "Your alarm named \(alarm.name) is going off!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error scheduling local user notifications \(error.localizedDescription)  :  \(error)")
            }
        }
        
    }
    
    func cancelUserNotification(for alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}


class AlarmController {
    
    let notificationIdentifier = "AlarmNotification"
    
    
    //Delegate
    weak var delegate: AlarmScheduler?
    
    //Singleton
    static let shared = AlarmController()
    
    
    
//    init() {
//        self.alarms = self.mockAlarms
//    }
    
    
    var alarms: [Alarm] = []
    
    var mockAlarms: [Alarm] = [
        Alarm(fireDate: Date(), name: "Alarm1"),
        Alarm(fireDate: Date(), name: "Alarm2"),
        Alarm(fireDate: Date(), name: "Alarm3")
    ]
    
    func addAlarm(fireDate: Date, name: String, enable: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarms.append(alarm)
        delegate?.scheduleUserNotification(for: alarm)
        saveToPersistenceStore()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enable: Bool) {
        guard let index = alarms.index(of : alarm) else { return }
        alarms[index].name = name
        alarms[index].fireDate = fireDate
        alarms[index].enable = enable
        delegate?.scheduleUserNotification(for: alarm)
        saveToPersistenceStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.index(of : alarm) else { return }
        alarms.remove(at: index)
        delegate?.cancelUserNotification(for: alarm)
        saveToPersistenceStore()
    }
    
    
    func toggleEnaled(for alarm: Alarm) {
        
        alarm.enable = !alarm.enable
        
        if alarm.enable {
            delegate?.scheduleUserNotification(for: alarm)
        } else {
            delegate?.cancelUserNotification(for: alarm)
        }
     
    }
    
    
    //Mark: - Persistence
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "Alarm.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    func saveToPersistenceStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print(error)
        }
    }
    
    func loadFromPersistenceStore() {
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch {
            print(error)
        }
    }
}
