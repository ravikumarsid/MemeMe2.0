//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by Ravi Kumar Venuturupalli on 1/28/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImageView.image = meme.memedImage
    }
}
