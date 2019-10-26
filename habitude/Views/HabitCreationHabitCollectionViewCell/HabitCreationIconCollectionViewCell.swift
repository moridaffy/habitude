//
//  HabitCreationIconCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitCreationIconCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var iconView: UIView!
  @IBOutlet private weak var iconImageView: UIImageView!
  
  private var viewModel: HabitCreationIconCollectionViewCellModel!
  
  func setup(viewModel: HabitCreationIconCollectionViewCellModel) {
    self.viewModel = viewModel
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = UIColor.clear
    iconView.backgroundColor = viewModel.color.color
    iconView.layer.cornerRadius = 30.0
    iconView.layer.masksToBounds = true
    iconImageView.image = viewModel.icon.icon
    iconImageView.tintColor = UIColor.white
  }
  
}
