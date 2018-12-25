//
//  ViewController.swift
//  ContactsApp
//
//  Created by Bharath  Raj kumar on 26/12/18.
//  Copyright © 2018 Bharath Raj Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Remote Outlets
    @IBOutlet weak var contactsTableView: UITableView!
    
    //Local Variables
    var contactViewModels = [ContactsViewModel]()
    var sectionArray = [sections]()
    var searchBarController: UISearchController!
    var searchStatus: Bool = false
    var searchtext = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchData()
        addSearchbar()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(contactCell.self, forCellReuseIdentifier: "contactsCell")
    }
    
    func addSearchbar()
    {
        
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self as? UISearchControllerDelegate
        searchBarController.searchBar.delegate = self
    }
    func fetchData()
    {
        Service.shared.fetchContacts(completion: {(contacts, err) in
            if let err = err
            {
                print("Error in fetching contacts, Description: \(err)")
            }
            
            print(contacts as Any)
            
            self.contactViewModels = contacts?.map({return ContactsViewModel(contacts: $0)}) ?? []
            
            // Sorting the array Objects
            self.contactViewModels = self.contactViewModels.sorted { $0.name < $1.name}
            
            //adding a grouped Dictionary
            self.contactsTableView.reloadData()
        })
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchStatus == true
        {
           //let predicatedText = NSPredicate(format: "name contains[c]", self.searchtext)
          //  let filteredArray = self.contactViewModels.filter { predicatedText.evaluate(with: $0)}
            let filteredArray = self.contactViewModels.filter{ $0.name.range(of: self.searchtext, options: [.caseInsensitive]) != nil }
            print(filteredArray.count)
            return filteredArray.count
        }
        else
        {
            return contactViewModels.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: contactCell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! contactCell
        if searchStatus == true
        {
            //let predicatedText = NSPredicate(format: "name contains[c] '\(([indexPath.row]))' ", self.searchtext)
           // let filteredArray = self.contactViewModels.filter { predicatedText.evaluate(with: $0)}
            let filteredArray = self.contactViewModels.filter{ $0.name.range(of: self.searchtext, options: [.caseInsensitive]) != nil }
            let contactsViewModel = filteredArray[indexPath.row]
            cell.contactViewModel = contactsViewModel
            print(cell.contactViewModel)
        }
        else
        {
            let contactsViewModel = contactViewModels[indexPath.row]
            cell.contactViewModel = contactsViewModel
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
extension ViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStatus = true
        searchtext = searchBarController.searchBar.text!
        self.contactsTableView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchStatus = false
        self.searchtext = ""
        self.contactsTableView.reloadData()
        self.view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBarController.searchBar.text?.count)! > 0
        {
          self.searchStatus = true
        }
        else
        {
            self.searchStatus = false
        }
        self.searchtext = searchBarController.searchBar.text!
        print(searchBarController.searchBar.text!)
        contactsTableView.reloadData()
    }
}

