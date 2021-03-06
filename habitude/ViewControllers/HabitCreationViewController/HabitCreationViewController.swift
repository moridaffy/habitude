//
//  HabitCreationViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift
import UIKit

protocol HabitCreationViewControllerDelegate: class {
  func didCreateNewHabit()
}

class HabitCreationViewController: UIViewController {
  
  @IBOutlet private weak var habitPreviewContainerView: UIView!
  @IBOutlet private weak var habitPreviewIconImageView: UIImageView!
  @IBOutlet private weak var habitNameLabel: UILabel!
  @IBOutlet private weak var habitNameTextField: UITextField!
  @IBOutlet private weak var habitIconLabel: UILabel!
  @IBOutlet private weak var habitIconCollectionView: UICollectionView!
  @IBOutlet private weak var habitColorLabel: UILabel!
  @IBOutlet private weak var habitColorCollectionView: UICollectionView!
  @IBOutlet private weak var habitTypeLabel: UILabel!
  @IBOutlet private weak var habitTypeSegmentSelector: UISegmentedControl!
  @IBOutlet private weak var habitTypeButton: UIButton!
  @IBOutlet private weak var instructionsLabel: UILabel!
  @IBOutlet private weak var createButton: UIButton!
  @IBOutlet private weak var createButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet private weak var createButtonBottomConstraint: NSLayoutConstraint!
  
  private let viewModel = HabitCreationViewModel()
  private let disposeBag = DisposeBag()
  private weak var delegate: HabitCreationViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.themableSecondaryBackground
    
    setupHabitPreview()
    setupNameTextField()
    setupIconCollectionView()
    setupColorCollectionView()
    setupTypeSelection()
    setupLabels()
    if #available(iOS 13.0, *) { } else {
      setupNavigationBar()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupCreateButton()
  }
  
  func setup(delegate: HabitCreationViewControllerDelegate) {
    self.delegate = delegate
  }
  
  private func setupHabitPreview() {
    habitPreviewContainerView.layer.cornerRadius = HabitCreationIconCollectionViewCell.cellSize.height / 4.0
    habitPreviewContainerView.layer.masksToBounds = true
    habitPreviewIconImageView.tintColor = UIColor.white
    
    viewModel.selectedHabitColor.asObservable()
      .subscribe { [weak self] (event) in
        guard let color = event.element?.color else { return }
        self?.habitPreviewContainerView.backgroundColor = color
        self?.habitTypeButton.tintColor = color
      }.disposed(by: disposeBag)
    
    viewModel.selectedHabitIcon.asObservable()
      .subscribe { [weak self] (event) in
        guard let icon = event.element else { return }
        self?.newHabitIconSelected(icon)
      }.disposed(by: disposeBag)
  }
  
  private func setupNameTextField() {
    habitNameTextField.setLeftPaddingPoints(8.0)
    habitNameTextField.setRightPaddingPoints(8.0)
    habitNameTextField.delegate = self
    habitNameTextField.layer.cornerRadius = 15.0
    habitNameTextField.layer.masksToBounds = true
    habitNameTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    habitNameTextField.textColor = UIColor.themableTextColor
    habitNameTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
  }
  
  private func setupIconCollectionView() {
    habitIconCollectionView.register(UINib(nibName: "HabitCreationIconCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "HabitCreationIconCollectionViewCell")
    habitIconCollectionView.backgroundColor = UIColor.clear
    habitIconCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    habitIconCollectionView.delegate = self
    habitIconCollectionView.dataSource = self
  }
  
  private func setupColorCollectionView() {
    habitColorCollectionView.register(UINib(nibName: "HabitCreationColorCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "HabitCreationColorCollectionViewCell")
    habitColorCollectionView.backgroundColor = UIColor.clear
    habitColorCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    habitColorCollectionView.delegate = self
    habitColorCollectionView.dataSource = self
  }
  
  private func setupTypeSelection() {
    if #available(iOS 13.0, *) {
      habitTypeSegmentSelector.selectedSegmentTintColor = UIColor.themableSecondaryBackground
    }
    habitTypeSegmentSelector.tintColor = UIColor.additionalRed
    habitTypeSegmentSelector.setTitleTextAttributes([.foregroundColor: UIColor.additionalRed], for: .normal)
    habitTypeSegmentSelector.removeAllSegments()
    habitTypeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Negative", comment: ""), at: 0, animated: false)
    habitTypeSegmentSelector.insertSegment(withTitle: NSLocalizedString("Positive", comment: ""), at: 0, animated: false)
    habitTypeSegmentSelector.selectedSegmentIndex = 0
    
    let habitTypeButtonIcon = #imageLiteral(resourceName: "icon_question_filled").withRenderingMode(.alwaysTemplate)
    habitTypeButton.setTitle(nil, for: .normal)
    habitTypeButton.setImage(habitTypeButtonIcon, for: .normal)
  }
  
  private func setupLabels() {
    for label in [habitNameLabel, habitIconLabel, habitColorLabel, habitTypeLabel, instructionsLabel] {
      label?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
      label?.textColor = UIColor.themableSecondaryTextColor
    }
    
    habitNameLabel.text = NSLocalizedString("Habit's name", comment: "")
    habitIconLabel.text = NSLocalizedString("Habit's icon", comment: "")
    habitColorLabel.text = NSLocalizedString("Habit's color", comment: "")
    habitTypeLabel.text = NSLocalizedString("Habit's type", comment: "")
    instructionsLabel.text = NSLocalizedString("HabitCreationViewController.Instructions", comment: "")
  }
  
  private func setupCreateButton() {
    guard !viewModel.createButtonConfigured else { return }
    viewModel.createButtonConfigured = true
    createButton.backgroundColor = UIColor.additionalRed
    createButton.setTitleColor(UIColor.white, for: .normal)
    createButton.setTitle(NSLocalizedString("Create", comment: "").uppercased(), for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    
    let bottomInset = view.safeAreaInsets.bottom
    guard bottomInset > 0.0 else { return }
    createButtonBottomConstraint.constant = -bottomInset
    createButtonHeightConstraint.constant = 50.0 + bottomInset
    createButton.contentEdgeInsets.bottom = bottomInset
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
  
  @IBAction private func habitTypeButtonTapped() {
    showHabitTypeAlert()
  }
  
  @IBAction private func createButtonTapped() {
    let habitName = viewModel.getHabitName(textFieldValue: habitNameTextField.text)
    viewModel.saveHabit(name: habitName, type: habitTypeSegmentSelector.selectedSegmentIndex == 0 ? .positive : .negative)
    delegate?.didCreateNewHabit()
    showSuccessAlert()
  }
  
  @objc private func closeButtonTapped() {
    dismissViewController()
  }
  
  private func newHabitIconSelected(_ icon: HabitIcon) {
    habitPreviewIconImageView.image = icon.icon?.withRenderingMode(.alwaysTemplate)
    
    let attributedPlaceholder = NSAttributedString(string: icon.placeholder,
                                                   attributes: [.foregroundColor: UIColor.themableSecondaryTextColor])
    habitNameTextField.attributedPlaceholder = attributedPlaceholder
  }
  
  private func showHabitTypeAlert() {
    let titleText = NSLocalizedString("Types of habits", comment: "")
    let bodyText = NSLocalizedString("HabitCreationViewModel.HabitTypeAlertBodyText", comment: "")
    let buttonText = NSLocalizedString("Ok", comment: "")
    showAlert(title: titleText, body: bodyText, button: buttonText, actions: [])
  }
  
  private func showSuccessAlert() {
    let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { [weak self] (_) in
      self?.dismissViewController()
    }
    showAlert(title: NSLocalizedString("Done", comment: ""), body: NSLocalizedString("Your habit was successfully created!", comment: ""), button: nil, actions: [okAction])
  }
  
  private func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}

extension HabitCreationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case habitIconCollectionView:
      return HabitCreationIconCollectionViewCell.cellSize
    case habitColorCollectionView:
      return HabitCreationColorCollectionViewCell.cellSize
    default:
      fatalError()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case habitIconCollectionView:
      viewModel.selectedHabitIcon.accept(viewModel.icons[indexPath.row])
    case habitColorCollectionView:
      viewModel.selectedHabitColor.accept(viewModel.colors[indexPath.row])
    default:
      break
    }
  }
}

extension HabitCreationViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case habitIconCollectionView:
      return viewModel.icons.count
    case habitColorCollectionView:
      return viewModel.colors.count
    default:
      fatalError()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case habitIconCollectionView:
      let reuseIdentifier = "HabitCreationIconCollectionViewCell"
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HabitCreationIconCollectionViewCell else { fatalError() }
      let icon = viewModel.icons[indexPath.row]
      let color = viewModel.getColorForIconPreview(at: indexPath.row)
      cell.setup(viewModel: HabitCreationIconCollectionViewCellModel(icon: icon, color: color))
      return cell
    case habitColorCollectionView:
      let reuseIdentifier = "HabitCreationColorCollectionViewCell"
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HabitCreationColorCollectionViewCell else { fatalError() }
      let color = viewModel.getColorForIconPreview(at: indexPath.row)
      cell.setup(viewModel: HabitCreationColorCollectionViewCellModel(color: color))
      return cell
    default:
      fatalError()
    }
  }
}

extension HabitCreationViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return false
  }
}
