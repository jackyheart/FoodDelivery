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
        let localDataSource = LocalDataSource()
        let repository = Repository(dataSource: localDataSource)
        let interactor = MenuInteractor(repository: repository)
        let router = MenuRouter()
        return MenuPresenter(interactor: interactor, router: router, view: view)
    }
    
    func generateMenuTypeButtonArray(titles: [String], topLeft: CGPoint,
                                     width: CGFloat, spacing: CGFloat, selector: Selector) -> [UIButton] {
        var btnArr: [UIButton] = []
        for i in 0 ..< titles.count {
            let title = titles[i]
            let rect = CGRect(x: topLeft.x + (CGFloat(i) * (width + spacing)),
                              y: topLeft.y, width: width, height: 30)
            let btn = UIButton(frame: rect)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(title, for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.addTarget(self, action: selector, for: .touchUpInside)
            btn.tag = i
            btnArr.append(btn)
        }
        return btnArr
    }
    
    func generateFiltersButtonArray(titles: [String], topLeft: CGPoint,
                                    width: CGFloat, spacing: CGFloat, selector: Selector) -> [UIButton] {
        var btnArr: [UIButton] = []
        let height: CGFloat = 20.0
        for i in 0 ..< titles.count {
            let title = titles[i]
            let rect = CGRect(x: topLeft.x + (CGFloat(i) * (width + spacing)),
                              y: topLeft.y, width: width, height: height)
            let btn = UIButton(frame: rect)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
            btn.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: selector, for: .touchUpInside)
            btn.layer.cornerRadius = height * 0.5
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            btn.layer.borderWidth = 1.0
            btn.tag = i
            btnArr.append(btn)
        }
        return btnArr
    }
}
