//
//  MenuRouter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

protocol MenuRouterProtocol {
    func navigateToOrderSummary()
}

class MenuRouter: MenuRouterProtocol {
    
    private var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateToOrderSummary() {
        
        print("navigateToOrderSummary, vc navcontrol: \(viewController?.navigationController)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyboard.instantiateViewController(withIdentifier: "Cart")
        viewController?.navigationController?.pushViewController(cartVC, animated: true)
    }
}
