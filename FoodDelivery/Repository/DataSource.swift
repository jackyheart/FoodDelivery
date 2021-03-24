//
//  DataSource.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 24/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation

protocol MenuDataSourceProtocol {
    func fetchMenu() -> [Food]
}
