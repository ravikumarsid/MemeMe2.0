//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ravi Kumar Venuturupalli on 1/27/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sentMemesTableView: UITableView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appdelegate.memes
        sentMemesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        memeDetailController.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailController, animated: true)
    }

}
