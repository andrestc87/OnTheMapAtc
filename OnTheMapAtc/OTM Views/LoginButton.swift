//
//  LoginButton.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor(red: 0.1451, green: 0.6039, blue: 0.9294, alpha: 1.0)
    }
}
