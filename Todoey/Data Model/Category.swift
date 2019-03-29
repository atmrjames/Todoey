//
//  Category.swift
//  Todoey
//
//  Created by James Harding on 12/03/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    //attribute definition
    
    let items = List<Item>()
    //relationship definition
    
}
