//
//  ContactCell.swift
//  Contacts Demo
//
//  Created by Charles Martin Reed on 12/12/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    //MARK: ViewController link
    var link: ViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //let's render out a favories icon using accessoryView
        let starButton = UIButton(type: .system)
        //starButton.setTitle("SOME TITLE", for: .normal)
        starButton.setImage(UIImage(named: "favStarIcon"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.tintColor = .red

        //button functionality
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        accessoryView = starButton
    }
    
    @objc private func handleMarkAsFavorite() {
        //we need to be able to determine WHICH cell we're tapping in so that we know who to favorite - link between cell to ViewController class
        guard let link = link else { return }
            link.someMethodToCall(cell: self) //we need the entire ContactCell class
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
