//
//  SettingsViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RxSwift
import StoreKit

class SettingsViewController: UIViewController {
  
  @IBOutlet private weak var themeLabel: UILabel!
  @IBOutlet private weak var themeSegmentSelector: UISegmentedControl!
  @IBOutlet private weak var badgeLabel: UILabel!
  @IBOutlet private weak var badgeSegmentSelector: UISegmentedControl!
  @IBOutlet private weak var aboutButton: UIButton!
  @IBOutlet private weak var aboutButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet private weak var aboutButtonBottomConstraint: NSLayoutConstraint!
  
  private let viewModel = SettingsViewModel()
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.themableSecondaryBackground
    
    setupReactive()
    setupThemeSelection()
    setupBadgeSelection()
    setupLabels()
    if #available(iOS 13.0, *) { } else {
      setupNavigationBar()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupAboutButton()
  }
  
  private func setupReactive() {
    themeSegmentSelector.rx.selectedSegmentIndex
      .skip(1)
      .subscribe() { [weak self] event in
        guard let newIndex = event.element else { return }
        self?.themeIndexChanged(to: newIndex)
    }.disposed(by: disposeBag)
    
    badgeSegmentSelector.rx.selectedSegmentIndex
      .skip(1)
      .subscribe() { [weak self] event in
        guard let newIndex = event.element else { return }
        self?.badgeIndexChanged(to: newIndex)
    }.disposed(by: disposeBag)
  }
  
  private func setupThemeSelection() {
    themeSegmentSelector.removeAllSegments()
    if #available(iOS 13.0, *) {
      themeSegmentSelector.selectedSegmentTintColor = UIColor.themableSecondaryBackground
      themeSegmentSelector.insertSegment(withTitle: "Automatic", at: 0, animated: false)
    }
    themeSegmentSelector.tintColor = UIColor.additionalRed
    themeSegmentSelector.setTitleTextAttributes([.foregroundColor: UIColor.additionalRed], for: .normal)
    themeSegmentSelector.insertSegment(withTitle: "Dark", at: 0, animated: false)
    themeSegmentSelector.insertSegment(withTitle: "Light", at: 0, animated: false)
    themeSegmentSelector.selectedSegmentIndex = viewModel.themeSelectedSegmentIndex
  }
  
  private func setupBadgeSelection() {
    if #available(iOS 13.0, *) {
      badgeSegmentSelector.selectedSegmentTintColor = UIColor.themableSecondaryBackground
    }
    badgeSegmentSelector.tintColor = UIColor.additionalRed
    badgeSegmentSelector.setTitleTextAttributes([.foregroundColor: UIColor.additionalRed], for: .normal)
    badgeSegmentSelector.removeAllSegments()
    badgeSegmentSelector.insertSegment(withTitle: "Nonactivated", at: 0, animated: false)
    badgeSegmentSelector.insertSegment(withTitle: "Activated", at: 0, animated: false)
    badgeSegmentSelector.insertSegment(withTitle: "None", at: 0, animated: false)
    badgeSegmentSelector.selectedSegmentIndex = viewModel.badgeSelectedSegmentIndex
  }
  
  private func setupLabels() {
    for label in [themeLabel, badgeLabel] {
      label?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
      label?.textColor = UIColor.themableSecondaryTextColor
    }
    
    themeLabel.text = "Theme"
    badgeLabel.text = "Badge value"
  }
  
  private func setupAboutButton() {
    guard !viewModel.aboutButtonConfigured else { return }
    viewModel.aboutButtonConfigured = true
    aboutButton.backgroundColor = UIColor.additionalRed
    aboutButton.setTitleColor(UIColor.white, for: .normal)
    aboutButton.setTitle("About".uppercased(), for: .normal)
    aboutButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    
    let bottomInset = view.safeAreaInsets.bottom
    guard bottomInset > 0.0 else { return }
    aboutButtonBottomConstraint.constant = -bottomInset
    aboutButtonHeightConstraint.constant = 50.0 + bottomInset
    aboutButton.contentEdgeInsets.bottom = bottomInset
  }
  
  private func setupNavigationBar() {
    let closeButtonIcon = #imageLiteral(resourceName: "icon_close").withRenderingMode(.alwaysTemplate)
    let closeButton = UIButton()
    closeButton.setTitle(nil, for: .normal)
    closeButton.setImage(closeButtonIcon, for: .normal)
    closeButton.tintColor = UIColor.additionalRed
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = UIColor.themableNavigationBarColor
    
    NSLayoutConstraint.activate([
      closeButton.widthAnchor.constraint(equalToConstant: 24.0),
      closeButton.heightAnchor.constraint(equalToConstant: 24.0)
    ])
  }
  
  @IBAction private func aboutButtonTapped() {
    let githubAction = UIAlertAction(title: "Github repository", style: .default) { (_) in
      guard let url = URL(string: DataManager.githubUrlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    let websiteAction = UIAlertAction(title: "My website", style: .default) { (_) in
      guard let url = URL(string: DataManager.mskrUrlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    let rateAction = UIAlertAction(title: "Rate in App Store", style: .default) { (_) in
      SKStoreReviewController.requestReview()
    }
    showAlert(title: "Habitude", body: viewModel.aboutAlertBodyText, button: "Ok", actions: [githubAction, websiteAction, rateAction])
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  private func themeIndexChanged(to index: Int) {
    viewModel.themeSelectedSegmentIndex = index
    showAlert(title: "Done", body: "Theme changed. Please, relaunch the app for the changes to take effect correctly.", button: "Ok", actions: nil)
  }
  
  private func badgeIndexChanged(to index: Int) {
    viewModel.badgeSelectedSegmentIndex = index
    NotificationManager.shared.updateBadgeValue { [weak self] (success) in
      guard !success else { return }
      self?.showAlertError(error: nil, desc: "Unable to set badge value. Please, check app's permissions in system settings app and try again", critical: false)
    }
  }
}
