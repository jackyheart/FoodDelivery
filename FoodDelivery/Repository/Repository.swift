//
//  Repository.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation

protocol MenuRepositoryProtocol {
    func requestMenu() -> [Food]
}

class Repository: MenuRepositoryProtocol {
    
    private var dataSource: MenuDataSourceProtocol
    
    init(dataSource: MenuDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func requestMenu() -> [Food] {
        return dataSource.fetchMenu()
    }
}
