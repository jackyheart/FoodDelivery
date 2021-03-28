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

enum CartTitle: String, CaseIterable {
    case cart
    case orders
    case information
}

protocol CartViewProtocol: class {
    func displayOrders(orders: Observable<[Order]>)
}

class CartViewController: UIViewController {
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    private var titleBtns: [UIButton] = []
    private var presenter: CartPresenter?
    private let disposeBag = DisposeBag()
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Menu", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        //empty title
        emptyLbl.isHidden = true
        
        //table view
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        cartTableView.delegate = self
    }
    
    private func configureButtons() {
        //configure title buttons
        titleBtns = Builder.shared.buildTitleButtonArray(titles: CartTitle.allCases.map({ $0.rawValue.capitalized }),
                                                         topLeft: CGPoint(x: 15.0, y: 70.0),
                                                         width: 120.0, spacing: 0.0,
                                                         target: self, selector: #selector(titleTapped(sender:)))
        
        for i in 0 ..< titleBtns.count {
            let btn = titleBtns[i]
            
            var color: UIColor = .lightGray
            if i == 0 {
                color = .black
            }
            btn.setTitleColor(color, for: .normal)
            
            self.view.addSubview(btn)
        }
        
        //configure checkout button
        checkOutBtn.layer.cornerRadius = checkOutBtn.bounds.width * 0.5
        checkOutBtn.layer.masksToBounds = true
        checkOutBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        checkOutBtn.layer.borderWidth = 1.0
        checkOutBtn.rx.tap.subscribe(onNext: {
            print("checkout!")
        }).disposed(by: disposeBag)
    }
    
    @objc private func titleTapped(sender: UIButton) {
        for btn in titleBtns {
            var color: UIColor = .lightGray
            if btn.tag == sender.tag {
                color = .black
            }
            btn.setTitleColor(color, for: .normal)
        }
    }
    
    @objc private func backTapped() {
        presenter?.onBackTapped()
    }
}

extension CartViewController: CartViewProtocol {
    
    func displayOrders(orders: Observable<[Order]>) {
        
        orders.bind(to: cartTableView.rx.items(cellIdentifier: "orderCell")) { index, order, cell in
            
            guard let orderCell = cell as? OrderCell else {
                return
            }
            
            orderCell.setOrderImage(imageName: order.food.imageName)
            orderCell.orderNameLbl.text = order.food.name
            
            let quantity = order.quantity
            let price = order.food.price
            orderCell.quantityLbl.text = "\(quantity) x SGD \(price)"
            orderCell.subtotalLbl.text = "SGD \(Double(quantity) * price)"
            
            orderCell.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
                
                let updatedOrder = self?.presenter?.onCancelOrderBtnTapped(order: order)
                updatedOrder?.subscribe(onNext: { (orderList) in
                    
                    print("order deleted!")
                    
                }).disposed(by: orderCell.disposeBag)
                
            }).disposed(by: orderCell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        orders.subscribe(onNext: { [weak self] in

            if $0.count == 0 {
                self?.emptyLbl.isHidden = false
            }
            
            if let presenter = self?.presenter {
                self?.totalPriceLbl.text = "SGD \(presenter.getTotal(orders: $0))"
            }
            
        }).disposed(by: disposeBag)
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
