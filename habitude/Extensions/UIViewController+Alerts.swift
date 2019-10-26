//
//  UIViewController+Alerts.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
    let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
    for action in (actions ?? []) {
      alert.addAction(action)
    }
    if let button = button {
      let lastButton = UIAlertAction(title: button, style: .cancel, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
      })
      alert.addAction(lastButton)
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  func showAlertError(error: Error?, desc: String?, critical: Bool) {
    var body: String = desc ?? NSLocalizedString("Произошла неизвестная ошибка", comment: "")
    if let error = error {
      body += "\n" + NSLocalizedString("Описание ошибки", comment: "") + ": \(error.localizedDescription)"
    }
    var button: String? {
      if critical {
        return nil
      } else {
        return "Ок"
      }
    }
    
    showAlert(title: NSLocalizedString("Ошибка", comment: ""), body: body, button: button, actions: nil)
  }
}
