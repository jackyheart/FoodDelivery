//
//  RemoteDataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

class RemoteDataSource: DataSourceProtocol {
    
    func fetchMenu() -> Observable<[Food]> {
        //fetch from api        
        return Observable.empty()
    }
    
    func addOrder(food: Food) {
        Database.shared.addOrder(food: food)
    }
    
    func fetchOrders() -> Observable<[Order]> {
        
        return Observable.create { (observer) -> Disposable in
            let orders = Database.shared.retrieveOrders()
            observer.onNext(orders)
            
            return Disposables.create { }
        }
    }
}
