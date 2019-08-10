//
//  ToDo.swift
//  To Do List
//
//  Created by  Джон Костанов on 09/08/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

import UIKit

class ToDo {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var image: UIImage?
    
    init(title: String = "", isComplete: Bool = false, dueDate: Date = Date(), notes:String? = nil, image: UIImage? = nil) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.image = image
    }
    
}
