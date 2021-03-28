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
        let repository = Repository.shared
        repository.dataSource = LocalDataSource()
        let interactor = MenuInteractor(repository: repository)
        let router = MenuRouter(viewController: (view as? UIViewController))
        return MenuPresenter(interactor: interactor, router: router, view: view)
    }
    
    func getCartPresenter(view: CartViewProtocol) -> CartPresenter {
        let interactor = CartInteractor(repository: Repository.shared)
        let router = CartRouter(viewController: (view as? UIViewController))
        return CartPresenter(interactor: interactor, router: router, view: view)
    }
    
    func buildTitleButtonArray(titles: [String], topLeft: CGPoint,
                               width: CGFloat, spacing: CGFloat,
                               fontSize: CGFloat,
                               target: Any?, selector: Selector) -> [UIButton] {
        var btnArr: [UIButton] = []
        for i in 0 ..< titles.count {
            let title = titles[i]
            let rect = CGRect(x: topLeft.x + (CGFloat(i) * (width + spacing)),
                              y: topLeft.y, width: width, height: 30)
            let btn = UIButton(frame: rect)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(title, for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.addTarget(target, action: selector, for: .touchUpInside)
            btn.tag = i
            btnArr.append(btn)
        }
        return btnArr
    }
    
    func buildOptionButtonArray(titles: [String], topLeft: CGPoint,
                                width: CGFloat, spacing: CGFloat,
                                target: Any?, selector: Selector) -> [UIButton] {
        var btnArr: [UIButton] = []
        let height: CGFloat = 20.0
        for i in 0 ..< titles.count {
            let title = titles[i]
            let rect = CGRect(x: topLeft.x + (CGFloat(i) * (width + spacing)),
                              y: topLeft.y, width: width, height: height)
            
            let grayColor = UIColor(displayP3Red: 192.0/255.0, green: 192.0/255.0,
                                    blue: 192.0/255.0, alpha: 1.0)
            let btn = UIButton(frame: rect)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
            btn.setTitleColor(grayColor, for: .normal)
            btn.setTitle(title, for: .normal)
            btn.addTarget(target, action: selector, for: .touchUpInside)
            btn.layer.cornerRadius = height * 0.5
            btn.layer.masksToBounds = true
            btn.layer.borderColor = grayColor.cgColor
            btn.layer.borderWidth = 1.0
            btn.tag = i
            btnArr.append(btn)
        }
        return btnArr
    }
}
