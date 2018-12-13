//
//  ViewController.swift
//  Contacts Demo
//
//  Created by Charles Martin Reed on 12/11/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    //MARK:- Properties
    let cellId = "cellId"
    
    //MARK:- Linking function
    //note: recommended to use custom delegation here instead of this sort of linking
    func someMethodToCall(cell: UITableViewCell) {        
        //figure out which name (row) we're clicking on
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        
        let hasFavorited = contact.hasFavorited
    twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //reloading the row lets us visually change the favorite star's tint color
        //tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? .lightGray : .red
    }
    
    var twoDimensionalArray = [ExpandableNames]()
//        ExpandableNames(isExpanded: true, names: ["Charles", "David", "Latricia", "Edna", "Wendy"].map { FavoritableContact(name: $0, hasFavorited: false)}),
//        ExpandableNames(isExpanded: true, names: ["Carla", "Clarence", "Chris", "Cynthia"].map { FavoritableContact(name: $0, hasFavorited: false)}),
//        ExpandableNames(isExpanded: true, names: ["Darius", "Derrick", "Denise", "Devin", "Doris"].map { FavoritableContact(name: $0, hasFavorited: false)}),
//        ExpandableNames(isExpanded: true, names: ["Patrick", "Patricia", "Peter", "Pedro"].map { FavoritableContact(name: $0, hasFavorited: false)}),
    
    var indexPathsToReload = [IndexPath]()
    
    var showIndexPaths = false //we'll flip this value to alternate between .left and .right reload animations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchContacts()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 16/255, blue: 0/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        //register custom cell for 'favorites' feature
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    //MARK:- Section header customization
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        //a button inside the header lets us execute code
        let button = UIButton(type: .system) //highlights when tapped
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(displayP3Red: 245/255, green: 120/255, blue: 48/255, alpha: 1)
        
        button.addTarget(self, action: #selector(handleHeaderExpandClose), for: .touchUpInside)
        
        //using tags to represent the section for each header, which we'll then use to determine which section to "collapse"
        button.tag = section
        
        return button
        
    }
    
    //MARK:- Helper methods
    private func fetchContacts() {
        //needs import Contacts to operate
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let error = err {
                print("Failed to request access", error.localizedDescription)
                return
            }
            
            if granted {
                print("Access granted!")
                
                //constructing the request with keys, request and completion block
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    
                    var favoritableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        //stop pointer terminates enumeration
                        
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                        
//                        favoritableContacts.append(FavoritableContact(name: "\(contact.givenName + " " + contact.familyName)", phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", hasFavorited: false))
                        
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
                } catch let err {
                    print("Failed to enumerate contacts", err)
                }
                
            } else {
                print("Access denied...")
            }
        }
        
        
    }
    
    @objc private func handleHeaderExpandClose(button: UIButton) {
        //create the illusion of collapsing and expanding by deleting (and reinserting) rows in the tableView
        let section = button.tag
        
        //try to close the section by deleting the rows
        var indexPaths = [IndexPath]()
        
        for row in twoDimensionalArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
        
        //changing the button title depending on whether the operation is to close or open
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        twoDimensionalArray[section].isExpanded = !isExpanded //use this value to figure out how many rows to return
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
    }
    
    @objc private func handleShowIndexPath() {
        //build all indexPaths we want to reload
        //reload the entire top section using a nested for-in loop
            for section in twoDimensionalArray.indices {
                for row in twoDimensionalArray[section].names.indices {
                    if twoDimensionalArray[section].isExpanded {
                        let indexPaths = IndexPath(row: row, section: section)
                        indexPathsToReload.append(indexPaths)
                        print(twoDimensionalArray[section])
                    } else {
                        return
                }
            }
        }
        
        //animation choice logic
        showIndexPaths = !showIndexPaths
        
        let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : .left
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
    }
    
    @objc private func removeIndexPaths(section: Int) {
       //placeholder
      
    }
  
    
    //MARK:- Table view methods
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count //we're using a 2D array, so the sections are the number of nested arrays
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !twoDimensionalArray[section].isExpanded { //if not expanded
            return 0
        }
        
        return twoDimensionalArray[section].names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //link the cell view to the view controller
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        //by default, cell won't have detailTextLabel style. Here's the fix for that.
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        let isExpanded = twoDimensionalArray[indexPath.section].isExpanded
        
        //favorite star tint color logic
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        if showIndexPaths {
            if isExpanded {
                cell.textLabel?.text = "\(favoritableContact.contact.givenName) - Section: \(indexPath.section), Row: \(indexPath.row)"
            }
        } else {
            cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        }
        
        return cell
    }

}

