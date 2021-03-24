//
//  RemoteDataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

class RemoteDataSource: MenuDataSourceProtocol {
    
    func fetchMenu() -> Observable<[Food]> {
        //fetch from api        
        return Observable.empty()
    }
}
