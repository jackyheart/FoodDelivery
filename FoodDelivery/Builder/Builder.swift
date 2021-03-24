//
//  Builder.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

class Builder {
    static let shared = Builder()

    func getMenuPresenter(view: MenuViewProtocol) -> MenuPresenter {
        let service = Service.shared
        let interactor = MenuInteractor(service: service)
        let router = MenuRouter()
        return MenuPresenter(interactor: interactor, router: router, view: view)
    }
}
