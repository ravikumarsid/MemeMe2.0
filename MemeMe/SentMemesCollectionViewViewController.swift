//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Ravi Kumar Venuturupalli on 1/27/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

class SentMemesCollectionViewViewController: UICollectionViewController{
  
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        memeCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
        let dimension_width = (self.view.frame.size.width - (2 * space)) / 3.0
        let dimension_height = (self.view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension_width, height: dimension_height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(memeDetailController, animated: true)
    }
    

}
