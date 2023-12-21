//
//  CollectionListVC.swift
//  Unsplash
//
//  Created by CubezyTech on 13/12/23.
//

import UIKit
import SoftButton
import Alamofire

class CollectionListVC:  UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var searchbarTxt: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    
    var pageNumber: Int = 1
    var images: [Result] = []
    var isFetchingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout()
        
        searchbarTxt.delegate = self
        
        fetchData(query: "Office", page: pageNumber)
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
    }
    func fetchData(query: String?, page: Int) {
        guard let query = query, !query.isEmpty else { return }
        
        ModelManager.shared.fetchImages(query: query, page: page) { [weak self] fetchedImages in
            guard let self = self, let fetchedImages = fetchedImages else { return }
            
            DispatchQueue.main.async {
                if self.pageNumber == 1 {
                    // Reset data on the first page
                    self.images = fetchedImages
                } else {
                    // Append to existing data for pagination
                    self.images.append(contentsOf: fetchedImages)
                }
                
                self.collectionview.reloadData()
                self.isFetchingData = false
            }
        }
    }
    func loadMoreData() {
        guard !isFetchingData else { return }
        
        isFetchingData = true
        pageNumber += 1
        fetchData(query: searchbarTxt.text, page: pageNumber)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.bounds.size.height
        
        if offsetY >= contentHeight && !isFetchingData {
            loadMoreData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pageNumber = 1
        fetchData(query: textField.text, page: pageNumber)
        return true
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    /*  private func resetDataAndFetch(pageNumber: Int, orderby: String) {
     images.removeAll()
     self.pageNumber = pageNumber
     fetchData(queryy: orderby, pagee: pageNumber)
     
     }*/
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionlistViewCell
        
        let item = images[indexPath.row]
        cell.imgView.sd_setImage(with: URL(string: item.coverPhoto.urls.small))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/1 - 10, height: 160)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "itemVC") as! ItemViewController
        vc.photoId = images[indexPath.row].id
        vc.totalPic = images[indexPath.row].totalPhotos
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
