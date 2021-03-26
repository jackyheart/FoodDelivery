//
//  Database.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

class Database {
    //simulate a Database
    static let shared = Database()
    private var orders: [Order] =  []
    
    func addOrder(food: Food) {
        if let orderIdx = orders.firstIndex(where: { $0.food.name == food.name }) {
            orders[orderIdx].quantity += 1
        } else {
            let order = Order(food: food, quantity: 1)
            orders.append(order)
        }
    }
    
    func retrieveOrder() -> [Order] {
        return orders
    }
}
