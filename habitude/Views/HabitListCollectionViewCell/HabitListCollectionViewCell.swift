//
//  HabitListCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 14.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitListCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var shadowView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet private weak var moreInfoButton: UIButton!
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  private var viewModel: HabitListCollectionViewCellModel!
  
  func setup(viewModel: HabitListCollectionViewCellModel) {
    self.viewModel = viewModel
    
    setupContainerView()
    setupHabit()
  }
  
  private func setupContainerView() {
    shadowView.backgroundColor = UIColor.clear
    shadowView.layer.shadowColor = viewModel.habit.color.cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 3.0
    shadowView.layer.shadowOffset = CGSize.zero
    shadowView.layer.masksToBounds = false
    containerView.layer.cornerRadius = 10.0
    containerView.layer.masksToBounds = true
    containerView.backgroundColor = viewModel.habit.color
  }
  
  private func setupHabit() {
    
  }
}
