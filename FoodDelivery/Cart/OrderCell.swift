//
//  OrderCell.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 27/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit
import RxSwift

class OrderCell: UITableViewCell {
    @IBOutlet weak var orderImgView: UIImageView!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderImgView.contentMode = .scaleAspectFill
        orderImgView.layer.masksToBounds = true
        orderImgView.backgroundColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrderImage(imageName: String) {
        let image = UIImage(named: imageName)
        orderImgView.image = image
    }
}
