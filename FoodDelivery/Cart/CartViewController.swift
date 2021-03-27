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
        configureViews()
        configureButtons()
    }
    
    private func configureViews() {
        
        //navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< menu", style: .plain, target: self, action: #selector(backTapped))
        
        //table view
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        cartTableView.delegate = self
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
    
    @objc private func backTapped() {
        presenter?.onBackTapped()
    }
}

extension CartViewController: CartViewProtocol {
    
    func displayOrders(orders: Observable<[Order]>) {
        
        orders.bind(to: cartTableView.rx.items(cellIdentifier: "orderCell")) { index, order, cell in
            
            let orderCell = cell as? OrderCell
            orderCell?.setOrderImage(imageName: order.food.imageName)
            orderCell?.orderNameLbl.text = order.food.name
            
            let quantity = order.quantity
            let price = order.food.price
            orderCell?.quantityLbl.text = "\(quantity) x SGD \(price)"
            orderCell?.subtotalLbl.text = "SGD \(Double(quantity) * price)"
            
        }.disposed(by: disposeBag)
        
        
        orders.subscribe(onNext: {

            if let presenter = self.presenter {
                self.totalPriceLbl.text = "SGD \(presenter.getTotal(orders: $0))"
            }
            
        }).disposed(by: disposeBag)
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
