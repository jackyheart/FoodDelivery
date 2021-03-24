//
//  Food.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import ObjectMapper

struct Food: Mappable {
    var name: String = ""
    var type: String = ""
    var description: String = ""
    var imageName: String = ""
    var price: Double = 0.0
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        description <- map["description"]
        imageName <- map["imageName"]
        price <- map["price"]
    }
}
