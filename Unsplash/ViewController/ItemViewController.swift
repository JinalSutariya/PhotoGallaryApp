//
//  ItemViewController.swift
//  Unsplash
//
//  Created by CubezyTech on 19/12/23.
//

import UIKit
import SoftButton

class ItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backBtn: SoftButton!
    var images: [ItemListDatum] = []
    var photoId = ""
    var totalPic = 0
    var pageNumber : Int = 0
    var isFetchingData: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photoId)
        self.navigationItem.setHidesBackButton(true, animated: true)
        fetchData()
        print(totalPic)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func fetchData() {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        ItemManager.shared.fetchImages(page: pageNumber, id: photoId) { [weak self] fetchedImages in
            guard let self = self, let fetchedImages = fetchedImages else {
                self!.isFetchingData = false
                return
            }
            
            self.isFetchingData = false
            self.images.append(contentsOf: fetchedImages)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if !isFetchingData {
                pageNumber += 1
                fetchData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ItemCollectionViewCell
        let item = images[indexPath.row]
        cell.imgView.sd_setImage(with: URL(string: item.urls.smallS3))
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
        let selectedImage = images[indexPath.row]
        showImageDetailViewController(image: selectedImage)
    }
    func showImageDetailViewController(image: ItemListDatum) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageDetailVC = storyboard.instantiateViewController(withIdentifier: "viewImage") as? ImageViewController {
            imageDetailVC.selectedImagee = image
            self.navigationController?.pushViewController(imageDetailVC, animated: true)
        }
    }
}

