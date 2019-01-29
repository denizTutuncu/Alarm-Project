//
//  Alarm.swift
//  Alarm
//
//  Created by Deniz Tutuncu on 1/28/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var fireDate: Date
    var name: String
    var enable: Bool
    let uuid: String

    init(fireDate: Date, name: String, enable: Bool = true, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.name = name
        self.enable = enable
        self.uuid = uuid
    }
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
    
}
//MARK: - Equatable
extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
}
