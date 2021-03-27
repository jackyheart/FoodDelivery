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
    
    func retrieveOrders() -> [Order] {
        return orders
    }
    
    func deleteOrder(order: Order) -> [Order] {
        if let index = orders.index(where: { $0.food == order.food }) {
            orders.remove(at: index)
        }
        return orders
    }
}
