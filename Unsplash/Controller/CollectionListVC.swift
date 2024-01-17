//
//  CollectionListVC.swift
//  Unsplash
//
//  Created by CubezyTech on 13/12/23.
//

import UIKit
import SoftButton
import Alamofire

class CollectionListVC:  UIViewController,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UITextFieldDelegate  {
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var searchbarTxt: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    var images: [Result] = []
    
    var pageNumber : Int = 0
    var isFetchingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout()
        collectionview.reloadData()
        searchbarTxt.delegate = self
        
        fetchData(page: pageNumber, query: "office")
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        // Perform search with the entered query
        if let query = textField.text, !query.isEmpty {
            resetDataAndFetch(query: query)
        }
        return true
    }
    
    func resetDataAndFetch(query: String) {
        pageNumber = 0
        images.removeAll()
        collectionview.reloadData()
        fetchData(page: pageNumber, query: query)
    }
    func fetchData(page: Int, query: String) {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        CollectionlistManager.shared.fetchImages(page: page, query: query) { [weak self] fetchedImages in
            
            guard let self = self, let fetchedImages = fetchedImages else {
                self?.isFetchingData = false
                return
            }
            
            self.isFetchingData = false
            self.images.append(contentsOf: fetchedImages)
            DispatchQueue.main.async {
                self.collectionview.reloadData()
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
                fetchData(page: pageNumber, query: searchbarTxt.text!)
            }
        }
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionListViewCell
        
        if let imageUrl = images[indexPath.item].coverPhoto?.urls.thumb {
            cell.configure(with: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/1 - 10, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "itemVC") as! ItemViewController
        vc.photoId = images[indexPath.item].id!
        vc.totalPic = images[indexPath.item].totalPhotos!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
