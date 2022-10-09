//
//  Registration.swift
//  HotelManzana
//
//  Created by Rajveer Singh on 07/10/22.
//

import Foundation

struct Registration {
    
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
}
