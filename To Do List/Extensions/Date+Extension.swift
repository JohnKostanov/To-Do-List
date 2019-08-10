//
//  Date+Extension.swift
//  To Do List
//
//  Created by  Джон Костанов on 10/08/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

import Foundation

extension Date {
    var formatedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
