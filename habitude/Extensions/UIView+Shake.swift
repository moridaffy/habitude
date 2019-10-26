//
//  UIView+Shake.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UIView {
  func shake(position: CGFloat = 7.0, repeats: Float = 3) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = repeats
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - position, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + position, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }
}
