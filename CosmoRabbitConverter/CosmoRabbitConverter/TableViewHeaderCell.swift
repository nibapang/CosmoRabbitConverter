//
//  TableViewHeaderCell.swift
//  SpatraCon
//
//  Created by Sudhanshu on 03/03/25.
//

import UIKit

class TableViewHeaderCell: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerTap: UIButton!
    
    var section: Int = 0
    var buttonAction: ((Int) -> Void)?
    
    

    @IBAction func headerButtonTapped(_ sender: UIButton) {
        buttonAction?(section)
        
        
    }
    
    // Function to update button image
    func updateButtonImage(isExpanded: Bool) {
        let imageName = isExpanded ? "chevron.compact.up" : "chevron.compact.down" // Replace with your asset names
        headerTap.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    
    
    
}
