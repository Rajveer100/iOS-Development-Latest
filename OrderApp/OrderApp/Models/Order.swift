//
//  Order.swift
//  OrderApp
//
//  Created by Rajveer Singh on 03/11/22.
//

import Foundation

struct Order: Codable {
    
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        
        self.menuItems = menuItems
    }
}
