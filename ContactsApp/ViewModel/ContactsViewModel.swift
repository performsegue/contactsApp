//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Bharath  Raj kumar on 26/12/18.
//  Copyright © 2018 Bharath Raj Kumar. All rights reserved.
//

import Foundation
import UIKit


struct ContactsViewModel
{
    var name: String
    
    init(contacts: Contacts)
    {
      self.name = contacts.name
    }
    
    
}


