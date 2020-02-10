//
//  Song.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 09/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import Foundation
import RealmSwift

class Song: Object {
    @objc dynamic var name = ""
    @objc dynamic var url = ""
    
    class func allObjects() -> Results<Song> {
        let realm = try! Realm()
        let songs = realm.objects(self)
        
        return songs
    }
    
    class func saveObjects() {
        FileManager.saveFiles()
        
        guard let arrayFiles = FileManager.allRecordedFiles() else { return }
        
        let realm = try! Realm()
        
        if arrayFiles.count != allObjects().count {
            for file in arrayFiles {
                let fileName = file.path.components(separatedBy: "/").last!
                
                let song = Song()
                song.name = fileName.components(separatedBy: ".").first!.replacingOccurrences(of: "_", with: " ")
                song.url = fileName
                
                try! realm.write {
                    realm.add(song)
                }
            }
        }
    }
}
