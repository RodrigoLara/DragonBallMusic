//
//  PlaylistViewController.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 08/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import UIKit
import RealmSwift

class PlaylistViewController: UIViewController {

    @IBOutlet weak var playlistTableView: UITableView!
    
    let songs = Song.allObjects()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonItem = UIBarButtonItem(image: UIImage(named: "User"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(profile))
        buttonItem.tintColor = .lightGray
        self.navigationItem.rightBarButtonItem = buttonItem

        playlistTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaylistCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "Play List" 
    }
    
    @objc func profile() {
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistCell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        
        let song = songs[indexPath.row]
        playlistCell.textLabel?.text = song.name
        
        playlistCell.accessoryType = .disclosureIndicator
        
        return playlistCell
    }
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerViewController = PlayerViewController(nibName: "PlayerViewController", bundle: nil)
        playerViewController.song = songs[indexPath.row]
        
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
}
