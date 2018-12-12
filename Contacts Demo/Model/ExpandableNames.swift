//
//  ExpandableNames.swift
//  Contacts Demo
//
//  Created by Charles Martin Reed on 12/11/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

public struct ExpandableNames {
    var isExpanded: Bool
    var names: [Contact]
}

struct Contact {
    var name: String
    var hasFavorited: Bool
}
