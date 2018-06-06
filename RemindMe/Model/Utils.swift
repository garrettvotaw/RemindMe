//
//  Utils.swift
//  RemindMe
//
//  Created by Garrett Votaw on 6/1/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
