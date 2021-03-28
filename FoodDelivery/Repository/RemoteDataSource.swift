//
//  RemoteDataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

class RemoteDataSource: DataSourceProtocol {
    
    let provider = MoyaProvider<MenuAPI>(stubClosure: MoyaProvider.delayedStub(0.5))
    
    func fetchMenu() -> Observable<[Food]> {
        
        return Observable.create { [weak self] (observer) -> Disposable in

            self?.provider.request(.getMenuList()) { result in
                
                switch result {
                case .success(let response):
                    do {
                        
                        if let jsonArr = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]] {
                            
                            let menu = Mapper<Food>().mapArray(JSONArray: jsonArr)
                            observer.onNext(menu)
                        }
                    } catch {
                        
                        let error = NSError(domain: "", code: -2, userInfo: ["reason": "couldn't decode JSON"])
                        observer.onError(error)
                    }
                case .failure:
                    
                    let error = NSError(domain: "", code: -1, userInfo: ["reason": "Server Not Available"])
                    observer.onError(error)
                }
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
