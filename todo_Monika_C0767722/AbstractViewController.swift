//
//  AbstractViewController.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-29.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController{
    
override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class var control: AbstractViewController {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! AbstractViewController
    }
}
