//
//  HabitCreationColorCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitCreationColorCollectionViewCell: HabitudeCollectionViewCell {
  
  @IBOutlet private weak var colorView: UIView!
  
  private var viewModel: HabitCreationColorCollectionViewCellModel!
  
  override class var cellSize: CGSize { return CGSize(width: 40.0, height: 40.0) }
  
  func setup(viewModel: HabitCreationColorCollectionViewCellModel) {
    self.viewModel = viewModel
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = UIColor.clear
    colorView.backgroundColor = viewModel.color.color
    colorView.layer.cornerRadius = (HabitCreationColorCollectionViewCell.cellSize.height - 8.0) / 2.0
    colorView.layer.masksToBounds = true
  }
}
