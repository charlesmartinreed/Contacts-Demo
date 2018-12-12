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
    
    let twoDimensionalArray = [
        ["Charles", "David", "Latricia", "Edna", "Wendy"],
        ["Carla", "Clarence", "Chris", "Cynthia"],
        ["Darius", "Derrick", "Denise", "Devin", "Doris"],
        ["Patrick", "Patricia", "Peter", "Pedro"]
    ]
    
    var showIndexPaths = false //we'll flip this value to alternate between .left and .right reload animations
    
    /*
    let salaryEmployees: [Person] = [
        Person(name: "Charles Reed", position: "CEO", phoneNumber: "111-111-1111", isSalaried: true),
        Person(name: "David Lowe", position: "CFO", phoneNumber: "111-111-2222", isSalaried: true),
        Person(name: "Latricia Reed", position: "CTO", phoneNumber: "111-111-3333", isSalaried: true),
//        Person(name: "Marvin Cotton", position: "Head of Recruiting", phoneNumber: "111-111-4444", isSalaried: true),
//        Person(name: "Edna Adams", position: "Head of Human Resources", phoneNumber: "111-111-5555", isSalaried: true)
        ]
    
    let hourlyEmployees: [Person] = [
        Person(name: "Dana White", position: "Customer Service Agent", phoneNumber: "111-222-1111", isSalaried: false),
        Person(name: "Jacob Stirling", position: "Custodial Lead", phoneNumber: "111-222-2222", isSalaried: false),
        Person(name: "Maya Behong", position: "Front Desk Associate", phoneNumber: "111-222-3333", isSalaried: false)
    ]
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Contacts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    //MARK:- Helper methods
    @objc private func handleShowIndexPath() {
        //build all indexPaths we want to reload
        var indexPathsToReload = [IndexPath]()
        
        //reload the entire top section using a nested for-in loop
        for section in twoDimensionalArray.indices {
            for row in twoDimensionalArray[section].indices {
                let indexPaths = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPaths)
            }
        }
        
        //animation choice logic
        showIndexPaths = !showIndexPaths
        
        let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : .left
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
    }
    
    //MARK:- Section header customization
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let salaryLabel = UILabel()
//        let hourlyLabel = UILabel()
//        let labels = [salaryLabel, hourlyLabel]
//
//        for label in labels {
//            if label == labels.first {
//                label.backgroundColor = .yellow
//                label.text = "Salary"
//            } else {
//                label.backgroundColor = .green
//                label.text = "Hourly"
//            }
//        }
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "Header"
        
        return label
    }
    
    //MARK:- Table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count //we're using a 2D array, so the sections are the number of nested arrays
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return twoDimensionalArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = twoDimensionalArray[indexPath.section][indexPath.row]
        
        if showIndexPaths {
        cell.textLabel?.text = "\(name) - Section: \(indexPath.section), Row: \(indexPath.row)"
        } else {
            cell.textLabel?.text = name
        }
        
        return cell
    }

}

