//
//  MenuInteractor.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

protocol MenuInteractorProtocol {
    func getMenuList() -> Observable<[Food]>
    func addOrder(food: Food)
    func getOrderList() -> Observable<[Order]>
}

class MenuInteractor: MenuInteractorProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getMenuList() -> Observable<[Food]> {
        return repository.requestMenu()
    }
    
    func addOrder(food: Food) {
        repository.addOrder(food: food)
    }
    
    func getOrderList() -> Observable<[Order]> {
        return repository.requestOrders()
    }
}
