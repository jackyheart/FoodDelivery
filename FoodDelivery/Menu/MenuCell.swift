//
//  MenuCell.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 25/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var bannerImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        priceBtn.layer.cornerRadius = 12
        priceBtn.layer.masksToBounds = true
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
