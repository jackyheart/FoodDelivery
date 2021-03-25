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

enum MenuType: Int {
    case pizza = 0
    case sushi
    case drinks
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    private let disposeBag = DisposeBag()
    
    private var presenter: MenuPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure UI
        configureUI()
        
        //get presenter
        presenter = Builder.shared.getMenuPresenter(view: self)
        presenter?.onViewDidLoad()
    }
    
    private func configureUI() {
        configureViews()
        configureButtons()
    }
    
    private func configureViews() {
        //configure container  view
        menuContainerView.layer.cornerRadius = 15
        menuContainerView.layer.masksToBounds = true
        
        //configure table view
        menuTableView.separatorStyle = .none
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.allowsSelection = false
        menuTableView.delegate = self
    }

    private func configureButtons() {
        //configure menu buttons
        let menuTypes = ["Pizza", "Sushi", "Drinks"]
        let btnMenuTypes = Builder.shared.generateMenuTypeButtonArray(titles: menuTypes, topLeft: CGPoint(x: 15.0, y: 5.0),
                                                                      width: 75.0, spacing: 35.0, selector: #selector(menuTypeTapped))
        for btn in btnMenuTypes {
            menuContainerView.addSubview(btn)
        }
        
        //configure filter buttons
        let filters = ["Spicy", "Vegan"]
        let btnFilters = Builder.shared.generateFiltersButtonArray(titles: filters, topLeft: CGPoint(x: 75.0, y: 48.0),
                                                                   width: 60.0, spacing: 15.0, selector: #selector(filterBtnTapped))
        for btn in btnFilters {
            menuContainerView.addSubview(btn)
        }
    }
    
    @objc func menuTypeTapped(sender: UIButton) {
        print("menu type tapped: \(sender.tag)")
    }
    
    @objc func filterBtnTapped(sender: UIButton) {
        print("filter tapped")
    }
}

extension MenuViewController: MenuViewProtocol {
    
    func displayMenu(menu: Observable<[Food]>) {
        
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
        return 320.0
    }
}
