//
//  HabitCreationIconCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitCreationIconCollectionViewCell: HabitudeCollectionViewCell {
  
  @IBOutlet private weak var iconView: UIView!
  @IBOutlet private weak var iconImageView: UIImageView!
  
  private var viewModel: HabitCreationIconCollectionViewCellModel!
  
  override class var cellSize: CGSize { return CGSize(width: 80.0, height: 80.0) }
  
  func setup(viewModel: HabitCreationIconCollectionViewCellModel) {
    self.viewModel = viewModel
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = UIColor.clear
    iconView.backgroundColor = viewModel.color.color
    iconView.layer.cornerRadius = HabitCreationIconCollectionViewCell.cellSize.height / 4.0
    iconView.layer.masksToBounds = true
    iconImageView.image = viewModel.icon.icon
    iconImageView.tintColor = UIColor.white
  }
  
}
