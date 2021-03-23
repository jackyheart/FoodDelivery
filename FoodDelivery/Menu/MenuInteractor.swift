//
//  MenuInteractor.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Foundation

protocol MenuInteractorProtocol: class {
    func getMenuList() -> [Food]
}

class MenuInteractor: MenuInteractorProtocol {

    private let service: ServiceProtocol

    init(service: ServiceProtocol) {
        self.service = service
    }

    func getMenuList() -> [Food] {
        return service.retrieveMenu()
    }
}
