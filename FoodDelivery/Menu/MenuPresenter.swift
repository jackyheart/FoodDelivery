//
//  MenuPresenter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

protocol MenuPresenterDelegate: class {
    func onMenuLoaded(menu: [Food])
}

class MenuPresenter {

    private let interactor: MenuInteractorProtocol
    private let router: MenuRouterProtocol
    weak var delegate: MenuPresenterDelegate?
    
    init(interactor: MenuInteractorProtocol, router: MenuRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func onViewDidLoad() {
        let menu = interactor.getMenuList()
        delegate?.onMenuLoaded(menu: menu)
    }
    
    func onNextPressed() {
        router.navigateToOrderSummary()
    }
}
