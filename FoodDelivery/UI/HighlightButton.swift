//
//  HighlightButton.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 28/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import UIKit

class HighlightButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .green : .black
        }
    }
}
