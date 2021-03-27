//
//  MenuCell.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 25/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit
import RxSwift

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var bannerImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //configure cell
        cellContainerView.layer.cornerRadius = 10
        cellContainerView.layer.masksToBounds = true
        cellContainerView.layer.borderWidth = 1.0
        cellContainerView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cellContainerView.backgroundColor = .clear
        
        bannerImgView.backgroundColor = .black
        
        //configure button        
        priceBtn.layer.cornerRadius = priceBtn.frame.height * 0.5
        priceBtn.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)
        bannerImgView.image = image
    }
    
    func setPriceBtnTitle(title: String) {
        priceBtn.setTitle(title, for: .normal)
    }
}
