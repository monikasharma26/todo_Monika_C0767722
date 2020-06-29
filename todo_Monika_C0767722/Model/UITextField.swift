//
//  UITextField.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    var hasText: Bool {
        return text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    func setLeftPading(_ size: CGFloat) {
        leftViewMode = .always
        let leftPadView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: bounds.size.height))
        leftPadView.backgroundColor = .clear
        leftView = leftPadView
    }
    
    func setBottomLine() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}

extension UIAlertController {
    
    // Shows alert view with completion block
    class func alert(_ title: String, message: String, buttons: [String], completion: ((_ : UIAlertController, _ : Int) -> Void)?) -> UIAlertController {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        // Add all other buttons
        return alertView!
    }
}

/*
 Extension for String
 */
extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

/*
 Extension for Date
 */
extension Date {
    
    func toString(withFormat format: String = "h:mm a,dd/MM/YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UIScreen {
    
    class var mainBounds: CGRect {
        return main.bounds
    }
    
    class var mainSize: CGSize {
        return mainBounds.size
    }
}

extension UIButton {
    
    var image: UIImage! {
        get {
            return image(for: .normal)!
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
}
