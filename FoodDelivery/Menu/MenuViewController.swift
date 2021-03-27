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

class MenuViewController: UIViewController {
    
    @IBOutlet weak var promotionScrollView: UIScrollView!
    @IBOutlet weak var promotionPageControl: UIPageControl!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var counterLbl: UILabel!
    
    private var initialTopConstraint: CGFloat = 0.0
    private var menuTypeBtns: [UIButton] = []
    private var presenter: MenuPresenter?
    private let disposeBag = DisposeBag()
    private var currentMenuType: MenuType = .pizza
    private let dataSource = BehaviorRelay(value: [Food]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure UI
        configureUI()
        
        //add gestures
        addGestures()
        
        //get presenter
        presenter = Builder.shared.getMenuPresenter(view: self)
        presenter?.onViewDidLoad()
    }
    
    private func configureUI() {
        configureViews()
        configureButtons()
        configureLabels()
    }
    
    private func addGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDected))
        leftSwipe.direction = .left
        menuTableView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDected))
        rightSwipe.direction = .right
        menuTableView.addGestureRecognizer(rightSwipe)
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
            promotionScrollView.delegate = self
        }
        
        //page control
        promotionPageControl.numberOfPages = numBanners
        
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
        menuTypeBtns = Builder.shared.generateMenuTypeButtonArray(titles: MenuType.allCases.map({ $0.rawValue.capitalized }),
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
        cartBtn.layer.cornerRadius = cartBtn.bounds.width * 0.5
        cartBtn.layer.masksToBounds = true
        cartBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cartBtn.layer.borderWidth = 1.0
        cartBtn.alpha = 0.0
        cartBtn.isHidden = true
        cartBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.presenter?.onCartBtnTapped()
            
        }).disposed(by: disposeBag)
    }
    
    private func configureLabels() {
        counterLbl.backgroundColor = UIColor(displayP3Red: 31.0/255.0, green: 177.0/255.0,
                                                  blue: 65.0/255.0, alpha: 1.0)
        counterLbl.layer.cornerRadius = self.counterLbl.bounds.width * 0.5
        counterLbl.layer.masksToBounds = true
        counterLbl.isHidden = true
    }
    
    @objc private func menuTypeTapped(sender: UIButton) {
        for btn in self.menuTypeBtns {
            var color: UIColor = .lightGray
            if btn.tag == sender.tag {
                color = .black
            }
            btn.setTitleColor(color, for: .normal)
        }
    }
    
    @objc private func filterBtnTapped(sender: UIButton) {
        print("filter tapped")
    }
    
    @objc private func swipeDected(gesture: UISwipeGestureRecognizer) {
        
        //TODO: send event to presenter
        
        /*
        if gesture.direction == .left {
            
            let idx = (currentMenuType.intVal + 1) % MenuType.allCases.count
            currentMenuType = MenuType.allCases[idx]
            
        } else if gesture.direction == .right {
            
            var idx = (currentMenuType.intVal - 1) % MenuType.allCases.count
            if idx < 0 {
                idx = MenuType.allCases.count - 1
            }
            currentMenuType = MenuType.allCases[idx]
        }
        */
    }
    
    private func showMenuByType(menu: Observable<[Food]>, type: MenuType) {
        menu.map({ $0.filter { $0.type == type.rawValue }})
            .bind(to: menuTableView.rx.items(cellIdentifier: "menuCell")) { index, food, cell in

                let menuCell = cell as? MenuCell
                menuCell?.nameLbl.text = food.name
                menuCell?.descLbl.text = food.description
                menuCell?.sizeLbl.text = food.size
                menuCell?.setImage(imageName: food.imageName)
                menuCell?.setPriceBtnTitle(title: "SGD \(food.price)")
                
                menuCell?.priceBtn.rx.tap.subscribe(onNext: {
                    //add menu item
                    self.presenter?.onAddMenu(food: food)
                }).disposed(by: self.disposeBag)

            }.disposed(by: disposeBag)
    }
}

extension MenuViewController: MenuViewProtocol {
    
    func displayMenu(menu: Observable<[Food]>) {
        //set initial display with type 'pizza'
        showMenuByType(menu: menu, type: currentMenuType)
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320.0
    }
}

extension MenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == promotionScrollView {
            //ignore if this is the promotion scroll view
            return
        }
        
        let yOffset = scrollView.contentOffset.y
        
        let temp = initialTopConstraint - (yOffset)
        
        if temp > 0.0 {
            menuTopConstraint.constant = temp
        } else {
            menuTopConstraint.constant = 0.0
        }
        
        promotionScrollView.alpha = (menuTopConstraint.constant / initialTopConstraint)
        
        if self.cartBtn.isHidden {
            self.cartBtn.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.cartBtn.alpha = 1.0
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == promotionScrollView {
            let page = floor(scrollView.contentOffset.x / scrollView.bounds.width)
            self.promotionPageControl.currentPage = Int(page)
        }
    }
}
