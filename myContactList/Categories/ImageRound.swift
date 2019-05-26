//
//  ImageRound.swift
//  myContactList
//
//  Created by lucy on 26/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import Foundation
import UIKit
class ImageRound: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

