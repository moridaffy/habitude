//
//  HabitCreationViewController.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RxSwift

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
  @IBOutlet private weak var createButtonBottomConstraint: NSLayoutConstraint!
  
  private let viewModel = HabitCreationViewModel()
  private let disposeBag = DisposeBag()
  private weak var delegate: HabitCreationViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupHabitPreview()
    setupNameTextField()
    setupIconCollectionView()
    setupColorCollectionView()
    setupTypeSelection()
    setupLabels()
    setupCreateButton()
    if #available(iOS 13.0, *) { } else {
      setupNavigationBar()
    }
  }
  
  func setup(delegate: HabitCreationViewControllerDelegate) {
    self.delegate = delegate
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
  
  private func setupHabitPreview() {
    habitPreviewContainerView.layer.cornerRadius = 30.0
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
        self?.habitPreviewIconImageView.image = icon.icon?.withRenderingMode(.alwaysTemplate)
        self?.habitNameTextField.placeholder = icon.placeholder
    }.disposed(by: disposeBag)
  }
  
  private func setupNameTextField() {
    habitNameTextField.setLeftPaddingPoints(8.0)
    habitNameTextField.setRightPaddingPoints(8.0)
    habitNameTextField.delegate = self
    habitNameTextField.layer.cornerRadius = 15.0
    habitNameTextField.layer.masksToBounds = true
    habitNameTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    habitNameTextField.textColor = UIColor.systemGray
    habitNameTextField.backgroundColor = UIColor.additionalGrayLight
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
    habitTypeSegmentSelector.removeAllSegments()
    habitTypeSegmentSelector.insertSegment(withTitle: "Negative", at: 0, animated: false)
    habitTypeSegmentSelector.insertSegment(withTitle: "Positive", at: 0, animated: false)
    habitTypeSegmentSelector.selectedSegmentIndex = 0
    
    let habitTypeButtonIcon = #imageLiteral(resourceName: "icon_question_filled").withRenderingMode(.alwaysTemplate)
    habitTypeButton.setTitle(nil, for: .normal)
    habitTypeButton.setImage(habitTypeButtonIcon, for: .normal)
  }
  
  private func setupLabels() {
    for label in [habitNameLabel, habitIconLabel, habitColorLabel, habitTypeLabel, instructionsLabel] {
      label?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
      label?.textColor = UIColor.systemGray
    }
    
    habitNameLabel.text = "Habit's name"
    habitIconLabel.text = "Habit's icon"
    habitColorLabel.text = "Habit's color"
    habitTypeLabel.text = "Habit's type"
    instructionsLabel.text = "Choose an icon and color for a new habit, enter its name (or use a template), select its type and click the \"create\" button"
  }
  
  private func setupCreateButton() {
    createButton.layer.cornerRadius = createButton.frame.height / 2.0
    createButton.layer.masksToBounds = true
    createButton.backgroundColor = UIColor.additionalPink
    createButton.setTitleColor(UIColor.white, for: .normal)
    createButton.setTitle("Create".uppercased(), for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
  }
  
  @IBAction private func habitTypeButtonTapped() {
    let body = """
    There are two types of habits in this app: positive and negative.

    Positive habits are regular habits which have to be completed everyday. For example, drink 1l of water, go to gym and so on.

    Negative habits are habits, which are automatically activated in the start of your day and must be deactivated if you fail to restrict yourself from doing something. For example, don't smoke, don't drink milk and so on.
    """
    showAlert(title: "Types of habits", body: body, button: "Ok", actions: [])
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
  
  private func showSuccessAlert() {
    let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
      self?.dismissViewController()
    }
    showAlert(title: "Done", body: "Your habit was successfully created!", button: nil, actions: [okAction])
  }
  
  private func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}

extension HabitCreationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case habitIconCollectionView:
      return CGSize(width: 100.0, height: 100.0)
    case habitColorCollectionView:
      return CGSize(width: 50.0, height: 50.0)
    default:
      fatalError()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case habitIconCollectionView:
      viewModel.selectedHabitIcon.value = viewModel.icons[indexPath.row]
    case habitColorCollectionView:
      viewModel.selectedHabitColor.value = viewModel.colors[indexPath.row]
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
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCreationIconCollectionViewCell", for: indexPath) as? HabitCreationIconCollectionViewCell else { fatalError() }
      let icon = viewModel.icons[indexPath.row]
      let color = viewModel.getColorForIconPreview(at: indexPath.row)
      cell.setup(viewModel: HabitCreationIconCollectionViewCellModel(icon: icon, color: color))
      return cell
    case habitColorCollectionView:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCreationColorCollectionViewCell", for: indexPath) as? HabitCreationColorCollectionViewCell else { fatalError() }
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
