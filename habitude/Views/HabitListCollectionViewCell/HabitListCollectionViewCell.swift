//
//  HabitListCollectionViewCell.swift
//  habitude
//
//  Created by Maxim Skryabin on 14.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm

protocol HabitListCollectionViewCellDelegate: class {
  func didActivateHabit(_ habit: Habit)
  func didTapDetailsButton(for habit: Habit)
}

class HabitListCollectionViewCell: HabitudeCollectionViewCell {
  
  @IBOutlet private weak var shadowView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet private weak var detailsButton: UIButton!
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  private var viewModel: HabitListCollectionViewCellModel!
  private weak var delegate: HabitListCollectionViewCellDelegate?
  private weak var longPressRecognizer: UILongPressGestureRecognizer?
  
  func setup(habit: Habit, delegate: HabitListCollectionViewCellDelegate?) {
    self.viewModel = HabitListCollectionViewCellModel(habit: habit)
    self.delegate = delegate
    
    setupContainerView()
    setupHabit()
    setupActions()
    setupReactive()
  }
  
  private func setupContainerView() {
    shadowView.backgroundColor = UIColor.clear
    shadowView.layer.shadowColor = viewModel.habit.color.cgColor
    shadowView.layer.shadowRadius = 3.0
    shadowView.layer.shadowOffset = CGSize.zero
    shadowView.layer.masksToBounds = false
    containerView.layer.cornerRadius = 10.0
    containerView.layer.masksToBounds = true
    containerView.layer.borderColor = viewModel.habit.color.cgColor
    containerView.backgroundColor = viewModel.habit.color
  }
  
  private func setupHabit() {
    counterLabel.textColor = UIColor.white
    titleLabel.text = viewModel.habit.name
    titleLabel.textColor = UIColor.white
    iconImageView.image = viewModel.habit.icon
    iconImageView.tintColor = UIColor.white
  }
  
  private func setupReactive() {
    Observable.from(viewModel.habit.activations)
      .subscribe { [weak self] (event) in
        guard let activations = event.element, !activations.isInvalidated else { return }
        let filteredActivations = activations.filter({ $0.isActive }).sorted(by: { $0.globalDay > $1.globalDay })
        let streakCount = Habit.getStreakCount(Array(filteredActivations))
        self?.counterLabel.text = "\(streakCount)"
        self?.updateActivatedState(activated: filteredActivations.first?.isToday ?? false)
    }.disposed(by: disposeBag)
  }
  
  private func setupActions() {
    let detailsButtonIcon = #imageLiteral(resourceName: "icon_details").withRenderingMode(.alwaysTemplate)
    detailsButton.setTitle(nil, for: .normal)
    detailsButton.setImage(detailsButtonIcon, for: .normal)
    detailsButton.tintColor = UIColor.white
    detailsButton.addTarget(self, action: #selector(didTapDetailsButton), for: .touchUpInside)
    
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didActivateHabit))
    longPressRecognizer.minimumPressDuration = 1.0
    containerView.addGestureRecognizer(longPressRecognizer)
    self.longPressRecognizer = longPressRecognizer
  }
  
  private func updateActivatedState(activated: Bool) {
    guard activated != viewModel.activated else { return }
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.containerView.backgroundColor = self?.viewModel.habit.color.withAlphaComponent(activated ? 1.0 : 0.5)
      self?.containerView.layer.borderWidth = activated ? 0.0 : 6.0
      self?.shadowView.layer.shadowOpacity = activated ? 1.0 : 0.0
    }, completion: { [weak self] _ in
      self?.viewModel.activated = activated
    })
  }
  
  @objc private func didTapDetailsButton() {
    delegate?.didTapDetailsButton(for: viewModel.habit)
  }
  
  @objc private func didActivateHabit(_ gesture: UILongPressGestureRecognizer) {
    guard gesture.state == .began else { return }
    delegate?.didActivateHabit(viewModel.habit)
  }
}
