//
//  CartPresenter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

class CartPresenter {
    
    private let interactor: CartInteractorProtocol
    private let router: CartRouterProtocol
    private weak var view: CartViewProtocol?
    
    init(interactor: CartInteractorProtocol, router: CartRouterProtocol, view: CartViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    func onViewDidLoad() {
        let orders = interactor.getOrderList()
        view?.displayOrders(orders: orders)
    }
}
