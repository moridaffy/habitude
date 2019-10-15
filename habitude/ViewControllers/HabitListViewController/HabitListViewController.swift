//
//  HabitListViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class HabitListViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private let viewModel = HabitListViewModel()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    setupReactive()
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeSettingsButton())
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeCreateButton())
  }
  
  private func setupCollectionView() {
    
    let sideInset: CGFloat = 4.0
    let cellWidth = collectionView.frame.width / 2.0  - sideInset * 2.0
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    
    collectionView.contentInset = UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
    collectionView.setCollectionViewLayout(layout, animated: false)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "HabitListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HabitListCollectionViewCell")
  }
  
  private func setupReactive() {
    
  }
  
  private func makeSettingsButton() -> UIButton {
    let settingsButtonIcon = UIImage(named: "icon_settings")
    let button = UIButton()
    button.setTitle(nil, for: .normal)
    button.setImage(settingsButtonIcon, for: .normal)
    button.tintColor = UIColor.black
    button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    return button
  }
  
  private func makeCreateButton() -> UIButton {
    let createButtonIcon = UIImage(named: "icon_plus")
    let button = UIButton()
    button.setTitle(nil, for: .normal)
    button.setImage(createButtonIcon, for: .normal)
    button.tintColor = UIColor.black
    button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    return button
  }
  
  @objc private func createButtonTapped() {
    guard let habitCreationViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "HabitCreationViewController") as? HabitCreationViewController else { fatalError() }
    present(habitCreationViewController, animated: true, completion: nil)
  }
  
  @objc private func settingsButtonTapped() {
    guard let settingsViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { fatalError() }
    present(settingsViewController, animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDelegate implementation

extension HabitListViewController: UICollectionViewDelegate {
  
}

// MARK: - UICollectionViewDataSource implementation

extension HabitListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.habits.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitListCollectionViewCell", for: indexPath) as? HabitListCollectionViewCell else { fatalError() }
    cell.setup(viewModel: HabitListCollectionViewCellModel(habit: viewModel.habits[indexPath.row]))
    return cell
  }
}
