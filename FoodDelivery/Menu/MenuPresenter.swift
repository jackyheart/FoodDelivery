//
//  MenuPresenter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

class MenuPresenter {

    private let interactor: MenuInteractorProtocol
    private let router: MenuRouterProtocol
    private let disposeBag = DisposeBag()
    private weak var view: MenuViewProtocol?

    init(interactor: MenuInteractorProtocol, router: MenuRouterProtocol, view: MenuViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    func onViewDidLoad() {
        let menu = interactor.getMenuList()
        view?.displayMenu(menu: menu)
    }
    
    func onCartBtnTapped() {
        router.navigateToOrderSummary()
    }
    
    func onAddMenu(food: Food) {
        interactor.addOrder(food: food)
        
        interactor.getOrderist().subscribe(onNext: { [weak self] in
            
            var total: Int = 0
            for order in $0 {
                total += order.quantity
            }
            
            self?.view?.updateCounter(counter: total)
            
        }).disposed(by: disposeBag)
    }
}
