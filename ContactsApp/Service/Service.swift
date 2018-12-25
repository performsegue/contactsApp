//
//  Service.swift
//  ContactsApp
//
//  Created by Bharath  Raj kumar on 26/12/18.
//  Copyright © 2018 Bharath Raj Kumar. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    
    
    func fetchContacts(completion: @escaping ([Contacts]?, Error?) -> ())
    {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch Contacts:", err)
                return
            }
            
            // check response
            
            guard let data = data else { return }
            do {
                let contacts = try JSONDecoder().decode([Contacts].self, from: data)
                DispatchQueue.main.async {
                    completion(contacts, nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            }.resume()

    }
}
