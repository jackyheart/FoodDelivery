//
//  Food.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import ObjectMapper

struct Food: Mappable, Equatable {
    var imageName: String = ""
    var name: String = ""
    var type: String = ""
    var description: String = ""
    var size: String = ""
    var price: Double = 0.0
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        imageName <- map["imageName"]
        name <- map["name"]
        type <- map["type"]
        description <- map["description"]
        size <- map["size"]
        price <- map["price"]
    }
    
    static func ==(lhs: Food, rhs: Food) -> Bool {
        return lhs.name == rhs.name
    }
}
