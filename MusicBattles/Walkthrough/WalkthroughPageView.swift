//
//  WalkthroughViewController.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 09/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import UIKit

class WalkthroughPageView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imagePage: UIImageView!
    @IBOutlet weak var titlePage: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)
        
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        Bundle.main.loadNibNamed("WalkthroughPageView", owner: self, options: nil)
        self.addSubview(self.view)
        self.view.frame = frame

    }
}
