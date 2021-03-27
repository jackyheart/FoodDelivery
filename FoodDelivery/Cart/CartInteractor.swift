//
//  CartInteractor.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

protocol CartInteractorProtocol {
    func getOrderList() -> Observable<[Order]>
}

class CartInteractor: CartInteractorProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getOrderList() -> Observable<[Order]> {
        return repository.requestOrders()
    }
}
