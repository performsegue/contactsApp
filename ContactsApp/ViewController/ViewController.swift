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
    @IBOutlet weak var reverseAlphabetFilterBarButton: UIBarButtonItem!
    @IBOutlet weak var alphabeticalBarButtonItem: UIBarButtonItem!
    
    
    //Local Variables
    var contactViewModels = [ContactsViewModel]()
    var sectionContactModel = [[Contacts]]()
    var firstLetterSorted = [String]()
    var searchBarController: UISearchController!
    var searchStatus: Bool = false
    var searchtext = ""
    var checkFilterSatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        fetchData()
        addSearchbar()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        //Registering the cell to Tableview
        contactsTableView.register(contactCell.self, forCellReuseIdentifier: "contactsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //to display the search controller
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    //Adding search Bar by using Searchcontroller
    func addSearchbar()
    {
        //Displaying the search Results in same View Controller and Same table view
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self as? UISearchControllerDelegate
        searchBarController.searchBar.delegate = self
    }
    
    
    // Reverse Filter
    @IBAction func reverseFilterAction(_ sender: Any) {
        
        if checkFilterSatus == false
        {
            //sorting the frist letter array which is used for section title Z-A
            self.firstLetterSorted.sort { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending }
            //Sorting the 2D Sectionsocntact model A-Z
            self.sectionContactModel.sort { $0[0].name > $1[0].name}
            self.checkFilterSatus = true
            // Enable the A-Z sort button
            self.navigationItem.leftBarButtonItem?.isEnabled = true
             //Disable the Z-A sort Button
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
       // self.firstLetterSorted.sort()
        self.contactsTableView.reloadData()
        
    }
    //Alphabetical Order Filter
    @IBAction func alphabeticalOrderAction(_ sender: Any) {
        //self.fetchData()
        
        if checkFilterSatus == true
        {
            //First letter sort A-Z
            self.firstLetterSorted.sort { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            //Sorting the 2D Sectionsocntact model A-Z
            self.sectionContactModel.sort { $0[0].name < $1[0].name}
            //checking if it's filtered Z-A
            self.checkFilterSatus = false
            // Disable the A-Z sort button
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            //Enable the Z-A sort Button
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        self.contactsTableView.reloadData()
    }
    
    //to fetch data from API
    func fetchData()
    {
        self.contactViewModels.removeAll()
        self.firstLetterSorted.removeAll()
        self.sectionContactModel.removeAll()
        Service.shared.fetchContacts(completion: {(contacts, err) in
            if let err = err
            {
                print("Error in fetching contacts, Description: \(err)")
            }
            
            print(contacts as Any)
            
            self.contactViewModels = contacts?.map({return ContactsViewModel(contacts: $0)}) ?? []
            
            // Sorting the array Objects Alphabetically A-Z
            self.contactViewModels = self.contactViewModels.sorted { $0.name < $1.name}
            let firstLetters = contacts?.map { $0.titleFirstLetter }
            let uniqueFirstLetters = Array(Set(firstLetters!))
            self.firstLetterSorted = uniqueFirstLetters.sorted()
            // Grouping the First letter with Respective Group of Contacts alphabetically
            self.sectionContactModel = self.firstLetterSorted.map { firstLetter in
                return (contacts?
                    .filter { $0.titleFirstLetter == firstLetter }
                    .sorted { $0.name < $1.name })!
            }
            
            print("Section Contact model \(self.sectionContactModel)")
            
            self.contactsTableView.reloadData()
        })
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    //Number of section remains 1 when search controller is active.
    //Number of section is returned with alphabets grouped with contacts.
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchStatus == true
        {
            return 1
        }
        else
        {
            return sectionContactModel.count
        }
        
    }
    
    //Fitering the contacts for the text to search and get the number of rows when search controller is active.
    //Displays the number of rows of all contacts.
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
            return sectionContactModel[section].count
        }
        
    }
    
    //Displays Search Result when the search Controller is active.
    //Displays all the contacts when search controller is inactive.
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
            cell.textLabel?.text = sectionContactModel[indexPath.section][indexPath.row].name
        }
        
        return cell
    }
    
   
    //Section Header Title. Nil while searchcontroller is active.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchStatus == true
        {
           return nil
        }
        else
        {
            return firstLetterSorted[section]
        }
    }
    
    //Section Indexing
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLetterSorted
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchtext = ""
        self.searchStatus = false
        self.contactsTableView.reloadData()
    }
}


