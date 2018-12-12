//
//  ViewController.swift
//  Contacts Demo
//
//  Created by Charles Martin Reed on 12/11/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //MARK:- Properties
    let cellId = "cellId"
    
    var twoDimensionalArray = [
        ExpandableNames(isExpanded: true, names: ["Charles", "David", "Latricia", "Edna", "Wendy"]),
        ExpandableNames(isExpanded: true, names: ["Carla", "Clarence", "Chris", "Cynthia"]),
        ExpandableNames(isExpanded: true, names: ["Darius", "Derrick", "Denise", "Devin", "Doris"]),
        ExpandableNames(isExpanded: true, names: ["Patrick", "Patricia", "Peter", "Pedro"])
    ]
    
    var indexPathsToReload = [IndexPath]()
    
    var showIndexPaths = false //we'll flip this value to alternate between .left and .right reload animations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Contacts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    //MARK:- Section header customization
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //a button inside the header lets us execute code
        let button = UIButton(type: .system) //highlights when tapped
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .yellow
        
        button.addTarget(self, action: #selector(handleHeaderExpandClose), for: .touchUpInside)
        
        //using tags to represent the section for each header, which we'll then use to determine which section to "collapse"
        button.tag = section
        
        return button
        
    }
    
    //MARK:- Helper methods
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
                if twoDimensionalArray[section].isExpanded {
                    for row in twoDimensionalArray[section].names.indices {
                        let indexPaths = IndexPath(row: row, section: section)
                        indexPathsToReload.append(indexPaths)
                    }
                } else {
                    return
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = twoDimensionalArray[indexPath.section].names[indexPath.row]
        let isExpanded = twoDimensionalArray[indexPath.section].isExpanded
        
        if showIndexPaths {
            if isExpanded {
                cell.textLabel?.text = "\(name) - Section: \(indexPath.section), Row: \(indexPath.row)"
            }
        } else {
            cell.textLabel?.text = name
        }
        
        return cell
    }

}

