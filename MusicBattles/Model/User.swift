//
//  User.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 09/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var photo = ""
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""
    @objc dynamic var desc = ""
    
    class func data() -> User? {
        let realm = try! Realm()
        
        return realm.objects(self).first
    }
    
    func save(photo: String, name: String, lastName: String, desc: String)  {
        let realm = try! Realm()
        
        self.photo = photo
        self.name = name
        self.lastName = lastName
        self.desc = desc
        
        try! realm.write {
            realm.add(self)
        }
    }
    
    func update(photo: String, name: String, lastName: String, desc: String) {
        let realm = try! Realm()
        
        guard let user = User.data() else { return }
        
        try! realm.write {
            user.photo = photo
            user.name = name
            user.lastName = lastName
            user.desc = desc
        }
    }
}
