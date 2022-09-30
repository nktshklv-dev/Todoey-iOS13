//
//  Item.swift
//  Todoey
//
//  Created by Nikita  on 9/29/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


struct Item: Codable{
    var title: String
    var isSelected: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
