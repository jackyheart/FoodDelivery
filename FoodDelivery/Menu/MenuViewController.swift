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
    
    @IBOutlet weak var promotionScrollView: UIScrollView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var counterLbl: UILabel!
    
    private var initialTopConstraint: CGFloat = 0.0
    private var menuTypeBtns: [UIButton] = []
    private var presenter: MenuPresenter?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure UI
        configureUI()
        
        //add gesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDected))
        swipeGesture.direction = .left
        menuTableView.addGestureRecognizer(swipeGesture)
        
        //get presenter
        presenter = Builder.shared.getMenuPresenter(view: self)
        presenter?.onViewDidLoad()
    }
    
    private func configureUI() {
        configureViews()
        configureButtons()
        configureLabels()
    }
    
    private func configureViews() {
        
        //add promotion banners
        let numBanners = 3
        for i in 0 ..< numBanners {
            let imageName = "promotion\(i+1)"
            let image = UIImage(named: imageName)
            
            let width = self.view.bounds.width
            let height = promotionScrollView.bounds.height
            
            let rect = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            let imgView = UIImageView(frame: rect)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.image = image
            
            promotionScrollView.contentSize = CGSize(width: CGFloat(numBanners) * width, height: height)
            promotionScrollView.addSubview(imgView)
            promotionScrollView.isPagingEnabled = true
        }
        
        //configure container view
        menuContainerView.layer.cornerRadius = 15
        menuContainerView.layer.masksToBounds = true
        
        //configure table view
        menuTableView.separatorStyle = .none
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.allowsSelection = false
        menuTableView.delegate = self
        
        //get initial top constraints
        initialTopConstraint = menuTopConstraint.constant
    }

    private func configureButtons() {
        //configure menu buttons
        let menuTypes = ["Pizza", "Sushi", "Drinks"]
        self.menuTypeBtns = Builder.shared.generateMenuTypeButtonArray(titles: menuTypes,
                                                                      topLeft: CGPoint(x: 15.0, y: 15.0),
                                                                      width: 75.0, spacing: 35.0,
                                                                      target: self, selector: #selector(menuTypeTapped(sender:)))
        for i in 0 ..< self.menuTypeBtns.count {
            let btn = self.menuTypeBtns[i]
            
            var color: UIColor = .lightGray
            if i == 0 {
                color = .black
            }
            btn.setTitleColor(color, for: .normal)
            
            menuContainerView.addSubview(btn)
        }
        
        //configure filter buttons
        let filters = ["Spicy", "Vegan"]
        let btnFilters = Builder.shared.generateFiltersButtonArray(titles: filters, topLeft: CGPoint(x: 75.0, y: 53.0),
                                                                   width: 60.0, spacing: 15.0,
                                                                   target: self, selector: #selector(filterBtnTapped(sender:)))
        for btn in btnFilters {
            menuContainerView.addSubview(btn)
        }
        
        //configure cart button
        self.cartBtn.layer.cornerRadius = self.cartBtn.bounds.width * 0.5
        self.cartBtn.layer.masksToBounds = true
        self.cartBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.cartBtn.layer.borderWidth = 1.0
        self.cartBtn.alpha = 0.0
        self.cartBtn.isHidden = true
    }
    
    private func configureLabels() {
        self.counterLbl.backgroundColor = UIColor(displayP3Red: 31.0/255.0, green: 177.0/255.0,
                                                  blue: 65.0/255.0, alpha: 1.0)
        self.counterLbl.layer.cornerRadius = self.counterLbl.bounds.width * 0.5
        self.counterLbl.layer.masksToBounds = true
        self.counterLbl.isHidden = true
    }
    
    @objc func menuTypeTapped(sender: UIButton) {
        for btn in self.menuTypeBtns {
            var color: UIColor = .lightGray
            if btn.tag == sender.tag {
                color = .black
            }
            btn.setTitleColor(color, for: .normal)
        }
    }
    
    @objc func filterBtnTapped(sender: UIButton) {
        print("filter tapped")
    }
    
    @objc private func swipeDected(gesture: UISwipeGestureRecognizer) {
        print("swipe dected")
    }
    
    @IBAction func cartTapped(_ sender: Any) {
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

extension MenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        let temp = initialTopConstraint - (yOffset)
        
        if temp > -100.0 {
            menuTopConstraint.constant = temp
        }
        
        promotionScrollView.alpha = (menuTopConstraint.constant / initialTopConstraint)
        
        if self.cartBtn.isHidden {
            self.cartBtn.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.cartBtn.alpha = 1.0
            }
        }
    }
}
