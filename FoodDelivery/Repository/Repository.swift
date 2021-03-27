//
//  Repository.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

protocol RepositoryProtocol {
    func requestMenu() -> Observable<[Food]>
    func addOrder(food: Food)
    func requestOrders() -> Observable<[Order]>
}

class Repository: RepositoryProtocol {
    static let shared = Repository()
    var dataSource: DataSourceProtocol = LocalDataSource()
    
    func requestMenu() -> Observable<[Food]> {
        return dataSource.fetchMenu()
    }
    
    func addOrder(food: Food) {
         dataSource.addOrder(food: food)
    }
    
    func requestOrders() -> Observable<[Order]> {
        return dataSource.fetchOrders()
    }
}
