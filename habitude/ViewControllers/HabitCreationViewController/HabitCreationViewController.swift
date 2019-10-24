//
//  HabitCreationViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class HabitCreationViewController: UIViewController {
  
  @IBOutlet private weak var habitPreviewContainerView: UIView!
  @IBOutlet private weak var habitPreviewIconImageView: UIImageView!
  @IBOutlet private weak var habitNameTextField: UITextField!
  @IBOutlet private weak var habitIconCollectionView: UICollectionView!
  @IBOutlet private weak var habitColorCollectionView: UICollectionView!
  @IBOutlet private weak var createButton: UIButton!
  
  private let viewModel = HabitCreationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard #available(iOS 13.0, *) else {
      setupNavigationBar()
      return
    }
  }
  
  private func setupNavigationBar() {
    let closeButtonIcon = #imageLiteral(resourceName: "icon_close").withRenderingMode(.alwaysTemplate)
    let closeButton = UIButton()
    closeButton.setTitle(nil, for: .normal)
    closeButton.setImage(closeButtonIcon, for: .normal)
    closeButton.tintColor = UIColor.black
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    
    NSLayoutConstraint.activate([
      closeButton.widthAnchor.constraint(equalToConstant: 24.0),
      closeButton.heightAnchor.constraint(equalToConstant: 24.0)
    ])
  }
  
  private func setupUI() {
    
  }
  
  private func setupCollectionViews() {
    
  }
  
  @IBAction private func createButtonTapped() {
    
  }
  
  @objc private func closeButtonTapped() {
    dismissViewController()
  }
  
  private func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}
