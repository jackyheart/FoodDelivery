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
    private weak var view: MenuViewProtocol?
    private let disposeBag = DisposeBag()
    
    init(interactor: MenuInteractorProtocol, router: MenuRouterProtocol, view: MenuViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    func onViewDidLoad() {
        let menu = interactor.getMenuList()
        menu.subscribe(onNext: { [weak self] (menuList) in
            self?.view?.displayMenu(menu: menuList)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func onNextPressed() {
        router.navigateToOrderSummary()
    }
}
