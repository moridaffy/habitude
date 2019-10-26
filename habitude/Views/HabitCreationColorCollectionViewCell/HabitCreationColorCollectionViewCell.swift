//
//  HabitCreationColorCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitCreationColorCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var colorView: UIView!
  
  private var viewModel: HabitCreationColorCollectionViewCellModel!
  
  func setup(viewModel: HabitCreationColorCollectionViewCellModel) {
    self.viewModel = viewModel
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = UIColor.clear
    colorView.backgroundColor = viewModel.color.color
    colorView.layer.cornerRadius = colorView.frame.height / 2.0
    colorView.layer.masksToBounds = true
  }
}
