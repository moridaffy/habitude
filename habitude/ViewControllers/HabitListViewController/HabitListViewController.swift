//
//  HabitListViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HabitListViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var placeholderLabel: UILabel!
  
  private let viewModel = HabitListViewModel()
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    setupPlaceholderLabel()
    setupReactive()
  }
  
  private func setupNavigationBar() {
    let settingsButton = getSettingsButton()
    let createButton = getCreateButton()
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
    
    NSLayoutConstraint.activate([
      settingsButton.widthAnchor.constraint(equalToConstant: 24.0),
      settingsButton.heightAnchor.constraint(equalToConstant: 24.0),
      createButton.widthAnchor.constraint(equalToConstant: 24.0),
      createButton.heightAnchor.constraint(equalToConstant: 24.0)
    ])
  }
  
  private func setupCollectionView() {
    let sideInset: CGFloat = 4.0
    let layout = getCollectionViewLayout(sideInset: sideInset)
    collectionView.setCollectionViewLayout(layout, animated: false)
    collectionView.contentInset = UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
    collectionView.register(UINib(nibName: "HabitListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HabitListCollectionViewCell")
  }
  
  private func setupPlaceholderLabel() {
    placeholderLabel.text = "Please, create a new habit using the + icon in the top right corner of the screen!"
    placeholderLabel.textColor = UIColor.systemGray
    placeholderLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
//    placeholderLabel.isHidden = !viewModel.habits.value.isEmpty
  }
  
  private func setupReactive() {
    viewModel.habits.asObservable()
      .bind(to: collectionView.rx.items) { collectionView, row, habit in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitListCollectionViewCell", for: IndexPath(row: row, section: 0)) as? HabitListCollectionViewCell else { fatalError() }
        cell.setup(habit: habit, delegate: self)
        return cell
      }.disposed(by: disposeBag)
    
    viewModel.habits.asObservable()
      .compactMap({ $0.isEmpty })
      .subscribe { [weak self] (event) in
        guard let displayPlaceholder = event.element else { return }
        self?.displayPlaceholderLabel(displayPlaceholder)
      }.disposed(by: disposeBag)
  }
  
  private func getSettingsButton() -> UIButton {
    let settingsButtonIcon = #imageLiteral(resourceName: "icon_settings").withRenderingMode(.alwaysTemplate)
    let button = UIButton()
    button.setTitle(nil, for: .normal)
    button.setImage(settingsButtonIcon, for: .normal)
    button.tintColor = UIColor.systemGray
    button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    return button
  }
  
  private func getCreateButton() -> UIButton {
    let createButtonIcon = #imageLiteral(resourceName: "icon_plus").withRenderingMode(.alwaysTemplate)
    let button = UIButton()
    button.setTitle(nil, for: .normal)
    button.setImage(createButtonIcon, for: .normal)
    button.tintColor = UIColor.systemGray
    button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    return button
  }
  
  private func getCollectionViewLayout(sideInset: CGFloat) -> UICollectionViewFlowLayout {
    let cellWidth = UIScreen.main.bounds.width / 2.0  - sideInset * 2.0
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    return layout
  }
  
  private func displayPlaceholderLabel(_ display: Bool) {
    placeholderLabel.isHidden = !display
  }
  
  // MARK: - Actions
  
  @objc private func createButtonTapped() {
    guard let habitCreationViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "HabitCreationViewController") as? HabitCreationViewController else { fatalError() }
    habitCreationViewController.setup(delegate: self)
    if #available(iOS 13.0, *) {
      present(habitCreationViewController, animated: true, completion: nil)
    } else {
      let navigationController = UINavigationController(rootViewController: habitCreationViewController)
      present(navigationController, animated: true, completion: nil)
    }
  }
  
  @objc private func settingsButtonTapped() {
    guard let settingsViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { fatalError() }
    if #available(iOS 13.0, *) {
      present(settingsViewController, animated: true, completion: nil)
    } else {
      let navigationController = UINavigationController(rootViewController: settingsViewController)
      present(navigationController, animated: true, completion: nil)
    }
  }
  
  private func tryToActivateHabit(_ habit: Habit) {
    if viewModel.canActivateHabit(habit) {
      HabitHelper.shared.activateHabit(habit: habit)
    } else {
      showAlertError(error: nil, desc: "Looks like habit has already been activated today! Come back tomorrow!", critical: false)
    }
  }
  
  private func showHabitDetailsAlert(_ habit: Habit) {
    let deleteAction = UIAlertAction(title: "Delete habit", style: .destructive) { (_) in
      DBManager.shared.deleteHabit(habit)
      self.viewModel.reloadHabits()
    }
    let activateAction = UIAlertAction(title: "Activate", style: .default) { (_) in
      self.tryToActivateHabit(habit)
    }
    showAlert(title: habit.name, body: "What do you want to do with selected habit?", button: "Cancel", actions: [deleteAction, activateAction])
  }
}

// MARK: - HabitListCollectionViewCellDelegate implementation

extension HabitListViewController: HabitListCollectionViewCellDelegate {
  func didActivateHabit(_ habit: Habit) {
    tryToActivateHabit(habit)
  }
  
  func didTapDetailsButton(for habit: Habit) {
    showHabitDetailsAlert(habit)
  }
}

// MARK: - HabitCreationViewControllerDelegate implementation

extension HabitListViewController: HabitCreationViewControllerDelegate {
  func didCreateNewHabit() {
    viewModel.reloadHabits()
  }
}
