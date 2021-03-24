//
//  MenuInteractor.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

protocol MenuInteractorProtocol {
    func getMenuList() -> [Food]
}

class MenuInteractor: MenuInteractorProtocol {

    private let repository: MenuRepositoryProtocol

    init(repository: MenuRepositoryProtocol) {
        self.repository = repository
    }

    func getMenuList() -> [Food] {
        return repository.requestMenu()
    }
}
