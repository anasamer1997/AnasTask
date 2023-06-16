//
//  extention.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import Foundation
import UIKit
extension UIViewController{
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "تنبيه", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
