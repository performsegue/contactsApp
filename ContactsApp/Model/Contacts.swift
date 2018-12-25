//
//  Contacts.swift
//  ContactsApp
//
//  Created by Bharath  Raj kumar on 26/12/18.
//  Copyright © 2018 Bharath Raj Kumar. All rights reserved.
//

import Foundation

struct Contacts: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
    var titleFirstLetter: String {
        return String(self.name[self.name.startIndex]).uppercased()
    }
}

struct Address: Decodable
{
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Decodable
{
    let lat: String
    let lng: String
}

struct Company: Decodable
{
    let name: String
    let catchPhrase: String
    let bs: String
}
