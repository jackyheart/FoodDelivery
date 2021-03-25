//
//  MenuViewController.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MenuViewProtocol: class {
    func displayMenu(menu: Observable<[Food]>)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    private let disposeBag = DisposeBag()
    
    private var presenter: MenuPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        presenter = Builder.shared.getMenuPresenter(view: self)
        presenter?.onViewDidLoad()
    }
}

extension MenuViewController: MenuViewProtocol {
    
    func displayMenu(menu: Observable<[Food]>) {
        
        print("binding menu to tableView")
        
        menu.bind(to: menuTableView.rx.items(cellIdentifier: "menuCell")) { index, menu, cell in
            
            let menuCell = cell as? MenuCell
            menuCell?.nameLbl.text = menu.name
            menuCell?.descLbl.text = menu.description
            menuCell?.sizeLbl.text = menu.size
            menuCell?.setImage(imageName: menu.imageName)
            menuCell?.setPriceBtnTitle(title: "SGD \(menu.price)")
            
        }.disposed(by: disposeBag)
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 314.0
    }
}
