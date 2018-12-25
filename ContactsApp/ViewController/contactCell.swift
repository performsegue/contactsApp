//
//  contactsCellController.swift
//  ContactsApp
//
//  Created by Bharath  Raj kumar on 26/12/18.
//  Copyright © 2018 Bharath Raj Kumar. All rights reserved.
//

import Foundation
import UIKit

class contactCell: UITableViewCell
{
    var contactViewModel: ContactsViewModel! {
        didSet {
            textLabel?.text = contactViewModel.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "contactsCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

