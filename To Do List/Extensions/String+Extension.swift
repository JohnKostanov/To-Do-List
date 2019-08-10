//
//  String+Extension.swift
//  To Do List
//
//  Created by  Джон Костанов on 10/08/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

extension String {
    var capitalizedSpaces: String {
        let withSpace = reduce("") { result, character in
            character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        
        return withSpace.capitalized
    }
}
