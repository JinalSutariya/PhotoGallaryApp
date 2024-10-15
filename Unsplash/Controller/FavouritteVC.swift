//
//  FavouritteVC.swift
//  Unsplash
//
//  Created by CubezyTech on 11/01/24.
//

import UIKit
protocol DataLoadDelegate: AnyObject {
    func loadDataForFavouritePageView()
}
class FavouritteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var favoriteImages: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout();
        loadFavoriteImages()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteImages()
    }
    func loadFavoriteImages() {
        print("loadFavoriteImages called")
        
        let imageDataArray = InsertDatabaseHelper.shared.getAllImages()
        favoriteImages.removeAll()
        
        for imageData in imageDataArray {
            if let image = UIImage(data: imageData) {
                favoriteImages.append(image)
                favoriteImages.reverse()
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouriteCollectionViewCell
        cell.imgView.image = favoriteImages[indexPath.item]
        
        return cell
    }
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerColumn: CGFloat = 3
    let spacingBetweenCells: CGFloat = 15
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerColumn - 1) * spacingBetweenCells) // Amount of total spacing in a column
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerColumn
            let height = 150
            return CGSize(width: width, height: CGFloat(height))
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = favoriteImages[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageDetailVC = storyboard.instantiateViewController(withIdentifier: "viewImage") as? ImageViewController {
            imageDetailVC.favImage = favoriteImages[indexPath.item]
            self.navigationController?.pushViewController(imageDetailVC, animated: true)
        }
    }
}

