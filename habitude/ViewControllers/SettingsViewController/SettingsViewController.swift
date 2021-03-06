//
//  SettingsViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift
import StoreKit
import UIKit

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
      .subscribe { [weak self] (event) in
        guard let newIndex = event.element else { return }
        self?.themeIndexChanged(to: newIndex)
      }.disposed(by: disposeBag)
    
    badgeSegmentSelector.rx.selectedSegmentIndex
      .skip(1)
      .subscribe { [weak self] event in
        guard let newIndex = event.element else { return }
        self?.badgeIndexChanged(to: newIndex)
      }.disposed(by: disposeBag)
  }
  
  private func setupThemeSelection() {
    themeSegmentSelector.removeAllSegments()
    if #available(iOS 13.0, *) {
      themeSegmentSelector.selectedSegmentTintColor = UIColor.themableSecondaryBackground
      themeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Automatic", comment: ""), at: 0, animated: false)
    }
    themeSegmentSelector.tintColor = UIColor.additionalRed
    themeSegmentSelector.setTitleTextAttributes([.foregroundColor: UIColor.additionalRed], for: .normal)
    themeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Dark", comment: ""), at: 0, animated: false)
    themeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Light", comment: ""), at: 0, animated: false)
    themeSegmentSelector.selectedSegmentIndex = viewModel.themeSelectedSegmentIndex
  }
  
  private func setupBadgeSelection() {
    if #available(iOS 13.0, *) {
      badgeSegmentSelector.selectedSegmentTintColor = UIColor.themableSecondaryBackground
    }
    badgeSegmentSelector.tintColor = UIColor.additionalRed
    badgeSegmentSelector.setTitleTextAttributes([.foregroundColor: UIColor.additionalRed], for: .normal)
    badgeSegmentSelector.removeAllSegments()
    badgeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Nonactivated", comment: ""), at: 0, animated: false)
    badgeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Activated", comment: ""), at: 0, animated: false)
    badgeSegmentSelector.insertSegment(withTitle: NSLocalizedString("None", comment: ""), at: 0, animated: false)
    badgeSegmentSelector.selectedSegmentIndex = viewModel.badgeSelectedSegmentIndex
  }
  
  private func setupLabels() {
    for label in [themeLabel, badgeLabel] {
      label?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
      label?.textColor = UIColor.themableSecondaryTextColor
    }
    
    themeLabel.text = NSLocalizedString("Theme", comment: "")
    badgeLabel.text = NSLocalizedString("Amount of habits on app's icon", comment: "")
  }
  
  private func setupAboutButton() {
    guard !viewModel.aboutButtonConfigured else { return }
    viewModel.aboutButtonConfigured = true
    aboutButton.backgroundColor = UIColor.additionalRed
    aboutButton.setTitleColor(UIColor.white, for: .normal)
    aboutButton.setTitle(NSLocalizedString("About", comment: "").uppercased(), for: .normal)
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
    showAboutAlert()
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  private func showAboutAlert() {
    let githubAction = UIAlertAction(title: NSLocalizedString("Github repository", comment: ""), style: .default) { (_) in
      guard let url = URL(string: DataManager.githubUrlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    let websiteAction = UIAlertAction(title: NSLocalizedString("My website", comment: ""), style: .default) { (_) in
      guard let url = URL(string: DataManager.mskrUrlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    let rateAction = UIAlertAction(title: NSLocalizedString("Rate in App Store", comment: ""), style: .default) { (_) in
      SKStoreReviewController.requestReview()
    }
    let bodyText = NSLocalizedString("SettingsViewModel.AboutAlertBodyText", comment: "")
    let buttonText = NSLocalizedString("Ok", comment: "")
    showAlert(title: "Habitude", body: bodyText, button: buttonText, actions: [githubAction, websiteAction, rateAction])
  }
  
  private func themeIndexChanged(to index: Int) {
    viewModel.themeSelectedSegmentIndex = index
    showAlert(title: "Done", body: NSLocalizedString("SettingsViewController.ThemeChanged", comment: ""), button: NSLocalizedString("Ok", comment: ""), actions: nil)
  }
  
  private func badgeIndexChanged(to index: Int) {
    viewModel.badgeSelectedSegmentIndex = index
    NotificationManager.shared.updateBadgeValue { [weak self] (success) in
      guard !success else { return }
      self?.showAlertError(error: nil, desc: NSLocalizedString("SettingsViewController.ErrorSettingBadge", comment: ""), critical: false)
    }
  }
}
