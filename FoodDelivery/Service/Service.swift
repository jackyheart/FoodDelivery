//
//  Service.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation

protocol ServiceProtocol: class {
    func retrieveMenu() -> [Food]
}

class Service: ServiceProtocol  {
    static let shared = Service()

    func retrieveMenu() -> [Food] {
        guard let path = Bundle.main.path(forResource: "menu", ofType: "json") else {
            print("path not found")
            return []
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let menu = try JSONDecoder().decode([Food].self, from: data)
            return menu
        } catch {
            print(error)
        }
        
        return []
    }
}
