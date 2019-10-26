//
//  UITextField+Padding.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UITextField {
  
  func setLeftPaddingPoints(_ amount: CGFloat){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    leftView = paddingView
    leftViewMode = .always
  }
  
  func setRightPaddingPoints(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    rightView = paddingView
    rightViewMode = .always
  }
  
}
