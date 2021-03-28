//
//  MenuPresenter.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 23/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import RxSwift

enum MenuType: String, CaseIterable {
    case pizza
    case sushi
    case drinks
    
    var intVal: Int {
        switch self {
        case .pizza:
            return 0
        case .sushi:
            return 1
        case .drinks:
            return 2
        }
    }
}

class MenuPresenter {

    private let interactor: MenuInteractorProtocol
    private let router: MenuRouterProtocol
    private weak var view: MenuViewProtocol?
    private var menuData: [Food] = []
    private var currentMenuType: MenuType = .pizza
    private let disposeBag = DisposeBag()

    init(interactor: MenuInteractorProtocol, router: MenuRouterProtocol, view: MenuViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    func onViewDidLoad() {
        let menu = interactor.getMenuList()
        
        menu.subscribe(onNext: { [weak self] in
            
            //hold reference to current unfiltered data
            self?.menuData = $0
            
            //set initial display with type 'pizza'
            self?.view?.displayMenu(menu: $0.filter({ $0.type == MenuType.pizza.rawValue }))
            
        }).disposed(by: disposeBag)
    }
    
    func onViewWillAppear() {
        updateCartCounter()
    }
    
    func onMenuTypeTapped(index: Int) {
        currentMenuType = MenuType.allCases[index]
        
        //filter
        let filteredMenu = menuData.filter({ $0.type == currentMenuType.rawValue })
        view?.displayMenu(menu: filteredMenu)
    }
    
    func onGestureDected(direction: UISwipeGestureRecognizer.Direction) {
        
        if direction == .left {
            
            let idx = (currentMenuType.intVal + 1) % MenuType.allCases.count
            currentMenuType = MenuType.allCases[idx]
            
        } else if direction == .right {
            
            var idx = (currentMenuType.intVal - 1) % MenuType.allCases.count
            if idx < 0 {
                idx = MenuType.allCases.count - 1
            }
            currentMenuType = MenuType.allCases[idx]
        }
        
        //filter
        let filteredMenu = menuData.filter({ $0.type == currentMenuType.rawValue })
        view?.displayMenu(menu: filteredMenu)
    }
    
    func onAddMenu(food: Food) {
        interactor.addOrder(food: food)
        updateCartCounter()
    }
    
    private func updateCartCounter() {
        interactor.getOrderList().subscribe(onNext: { [weak self] in
            
            var total: Int = 0
            for order in $0 {
                total += order.quantity
            }
            
            self?.view?.updateCounter(counter: total)
            
        }).disposed(by: disposeBag)
    }
    
    func onCartBtnTapped() {
        router.navigateToOrderSummary()
    }
}
