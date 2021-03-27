//
//  CartViewController.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CartViewProtocol: class {
    func displayOrders(orders: Observable<[Order]>)
}

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    private var presenter: CartPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure UI
        configureUI()
        
        //get presenter
        presenter = Builder.shared.getCartPresenter(view: self)
        presenter?.onViewDidLoad()
    }
    
    private func configureUI() {
        configureButtons()
    }
    
    private func configureButtons() {
        //configure checkout button
        checkOutBtn.layer.cornerRadius = checkOutBtn.bounds.width * 0.5
        checkOutBtn.layer.masksToBounds = true
        checkOutBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        checkOutBtn.layer.borderWidth = 1.0
        checkOutBtn.rx.tap.subscribe(onNext: {
            print("checkout!")
        }).disposed(by: disposeBag)
    }
}

extension CartViewController: CartViewProtocol {
    
    func displayOrders(orders: Observable<[Order]>) {
        
    }
}
