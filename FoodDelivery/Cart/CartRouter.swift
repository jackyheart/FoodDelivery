//
//  CartRouter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

protocol CartRouterProtocol {
    func navigateBackToMenu()
}

class CartRouter: CartRouterProtocol {
    
    private var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateBackToMenu() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
