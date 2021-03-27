//
//  LocalDataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class LocalDataSource: DataSourceProtocol {
    
    func fetchMenu() -> Observable<[Food]> {
        
        return Observable.create { (observer) -> Disposable in
            
            guard let path = Bundle.main.path(forResource: "menu", ofType: "json") else {
                let error = NSError(domain: "", code: -1, userInfo: ["reason": "path not found"])
                observer.onError(error)
                return Disposables.create { }
            }
            
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                
                do {
                    if let jsonArr = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                       let menu = Mapper<Food>().mapArray(JSONArray: jsonArr)
                        observer.onNext(menu)
                    }
                    
                } catch {
                    let error = NSError(domain: "", code: -2, userInfo: ["reason": "couldn't decode JSON"])
                    observer.onError(error)
                    return Disposables.create { }
                }
                
            } catch {
                print(error)
            }

            return Disposables.create { }
        }
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
    
    func removeOrder(order: Order) -> Observable<[Order]> {
        
        return Observable.create { (observer) -> Disposable in
            let orders = Database.shared.deleteOrder(order: order)
            observer.onNext(orders)
            
            return Disposables.create { }
        }
    }
}
