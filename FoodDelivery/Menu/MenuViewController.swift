//
//  MenuViewController.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

protocol MenuViewProtocol: class {
    func displayMenu(menu: [Food])
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuContainerView: UIView!
    
    private var presenter: MenuPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        presenter = Builder.shared.getMenuPresenter(view: self)
        presenter?.onViewDidLoad()
    }
}

extension MenuViewController: MenuViewProtocol {
    
    func displayMenu(menu: [Food]) {
        //update table view
        print("gotten the menu, ready to be displayed")
        print(menu)
    }
}

