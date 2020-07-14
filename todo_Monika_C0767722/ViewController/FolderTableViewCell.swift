//
//  FolderTableViewCell.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-07-01.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

   
      
       @IBOutlet var name_lbl: UILabel!
      
       
       // MARK: - Life Cycle
       override func awakeFromNib() {
           super.awakeFromNib()
           
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }
       
       // MARK: - Helper
       func setDisplay(customer: Folder) {
           //
           name_lbl.text = customer.name
          
          
       }
}
