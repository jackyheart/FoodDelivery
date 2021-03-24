//
//  Builder.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

class Builder {
    static let shared = Builder()

    func getMenuPresenter(view: MenuViewProtocol) -> MenuPresenter {
        let localDataSource = LocalDataSource()
        let repository = Repository(dataSource: localDataSource)
        let interactor = MenuInteractor(repository: repository)
        let router = MenuRouter()
        return MenuPresenter(interactor: interactor, router: router, view: view)
    }
}
