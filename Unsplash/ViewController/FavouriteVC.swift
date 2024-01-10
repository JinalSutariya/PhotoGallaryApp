//
//  FavouriteVC.swift
//  Unsplash
//
//  Created by CubezyTech on 05/01/24.
//

import UIKit

class FavouriteVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray: [UIImage] = [] // Assume imageData is an array of Data representing your images

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout();

    }

    @IBAction func backTap(_ sender: Any) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouriteCollectionViewCell
           let image = imageArray[indexPath.item]

                  // Convert UIImage to Data
                  if let imageData = image.pngData() {
                      cell.imgView.image = image
                  }

           return cell
       }
}
