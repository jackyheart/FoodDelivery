//
//  DataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

protocol MenuDataSourceProtocol {
    func fetchMenu() -> Observable<[Food]>
}
