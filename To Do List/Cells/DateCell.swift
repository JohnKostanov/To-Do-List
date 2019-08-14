//
//  DateCell.swift
//  To Do List
//
//  Created by  Джон Костанов on 13/08/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    func setDate(_ date: Date) {
        label.text = date.formatedDate
    }
}
