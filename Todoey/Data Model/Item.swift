//
//  Item.swift
//  Todoey
//
//  Created by James Harding on 12/03/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //attribute definition
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //relationship definition
    
}
