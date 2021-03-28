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
    func showError(errorMessage: String)
}

enum CartTitle: String, CaseIterable {
    case cart
    case orders
    case info
}

class CartViewController: UIViewController {
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    private var titleBtns: [UIButton] = []
    private var presenter: CartPresenter?
    
    //Rx
    private let rxDataSource = BehaviorRelay(value: [Order]())
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
        
        //empty message
        emptyLbl.isHidden = true
        
        //table view
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        cartTableView.delegate = self
        
        //bind table view
        rxDataSource.asObservable()
            .bind(to: cartTableView.rx.items(cellIdentifier: "orderCell")) { index, order, cell in
            
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
                updatedOrder?
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] in
                        
                        self?.rxDataSource.accept($0)
                        self?.updateTotalPrice(orders: $0)
                        
                    }, onError: { [weak self] error in
                        self?.showError(errorMessage: error.localizedDescription)
                    }
                ).disposed(by: orderCell.disposeBag)
                
            }).disposed(by: orderCell.disposeBag)
            
            }.disposed(by: disposeBag)
    }
    
    private func configureButtons() {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        var navBarHeight: CGFloat = 0.0
        if let navBar = navigationController?.navigationBar {
            navBarHeight = navBar.frame.height
        }
        
        //configure title buttons
        titleBtns = Builder.shared.buildTitleButtonArray(titles: CartTitle.allCases.map({ $0.rawValue.capitalized }),
                                                         topLeft: CGPoint(x: 15.0, y: statusBarHeight + navBarHeight),
                                                         width: 90.0, spacing: 35.0,
                                                         fontSize: 25.0,
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
        checkOutBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            //print("checkout!")
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to checkout?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                print("ok tapped")
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true, completion: nil)
            
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
    
    private func updateTotalPrice(orders: [Order]) {
        //show/hide empty message
        emptyLbl.isHidden = (orders.count == 0) ? false : true
        
        //display total
        if let presenter = self.presenter {
            totalPriceLbl.text = "SGD \(presenter.getTotal(orders: orders))"
        }
    }
}

extension CartViewController: CartViewProtocol {
    
    func displayOrders(orders: Observable<[Order]>) {
        orders
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                self?.rxDataSource.accept($0)
                self?.updateTotalPrice(orders: $0)
                
            }, onError: { [weak self] error in
                self?.showError(errorMessage: error.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
    
    func showError(errorMessage: String) {
        print(errorMessage)
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
