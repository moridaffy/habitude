//
//  HabitListCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 14.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

protocol HabitListCollectionViewCellDelegate: class {
  func didActivateHabit(_ habit: Habit)
  func didTapDetailsButton(for habit: Habit)
}

class HabitListCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var shadowView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet private weak var detailsButton: UIButton!
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  private var viewModel: HabitListCollectionViewCellModel!
  private weak var delegate: HabitListCollectionViewCellDelegate?
  private weak var longPressRecognizer: UILongPressGestureRecognizer?
  
  func setup(habit: Habit, delegate: HabitListCollectionViewCellDelegate?) {
    self.viewModel = HabitListCollectionViewCellModel(habit: habit)
    self.delegate = delegate
    
    setupContainerView()
    setupHabit()
    setupActions()
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
    // TODO
    // counterLabel.text = ???
    counterLabel.textColor = viewModel.habit.iconColor
    titleLabel.text = viewModel.habit.name
    titleLabel.textColor = viewModel.habit.iconColor
    iconImageView.image = viewModel.habit.icon
    iconImageView.tintColor = viewModel.habit.iconColor
  }
  
  private func setupActions() {
    detailsButton.setTitle(nil, for: .normal)
    detailsButton.setImage(UIImage(named: "icon_details")?.withRenderingMode(.alwaysTemplate), for: .normal)
    detailsButton.tintColor = viewModel.habit.iconColor
    detailsButton.addTarget(self, action: #selector(didTapDetailsButton), for: .touchUpInside)
    
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didActivateHabit))
    longPressRecognizer.minimumPressDuration = 1.0
    containerView.addGestureRecognizer(longPressRecognizer)
    self.longPressRecognizer = longPressRecognizer
  }
  
  @objc private func didTapDetailsButton() {
    delegate?.didTapDetailsButton(for: viewModel.habit)
  }
  
  @objc private func didActivateHabit(_ gesture: UILongPressGestureRecognizer) {
    guard gesture.state == .began else { return }
    delegate?.didActivateHabit(viewModel.habit)
  }
}
