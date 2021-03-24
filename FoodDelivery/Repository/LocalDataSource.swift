//
//  LocalDataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation
import RxSwift

class LocalDataSource: MenuDataSourceProtocol {
    
    func fetchMenu() -> Observable<[Food]> {
        
        return Observable.create({ (observer) -> Disposable in
            
            guard let path = Bundle.main.path(forResource: "menu", ofType: "json") else {
                let error = NSError(domain: "", code: -1, userInfo: ["reason": "path not found"])
                observer.onError(error)
                return Disposables.create { }
            }
            
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                let menu = try JSONDecoder().decode([Food].self, from: data)
                observer.onNext(menu)
            } catch {
                print(error)
            }

            return Disposables.create { }
        })
    }
}
