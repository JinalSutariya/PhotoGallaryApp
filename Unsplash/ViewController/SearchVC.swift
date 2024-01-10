//
//  SearchVC.swift
//  Unsplash
//
//  Created by CubezyTech on 11/12/23.
//

import UIKit
import Alamofire
import SoftButton

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var searchTxt: UITextField!
    
   /* var images: [UnsplashPhoto] = []
    var pageNumber : Int = 0
    var isPageRefreshing : Bool = false*/
    
    var images: [Resulttt] = []
    
    var pageNumber : Int = 0
    var isFetchingData: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout();
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
        
        searchTxt.delegate = self
        
    //    searchImages(page: pageNumber)
        fetchData(query: "office")
    }
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
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
        fetchData(query: query)
    }
    func fetchData(query: String) {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        searchPhotos.shared.fetchImages(page: pageNumber, query: query) { [weak self] fetchedImages in
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
                fetchData(query: searchTxt.text!)
            }
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SearchCollectionView
       /* if let imageUrl = images[indexPath.item].coverPhoto?.urls.thumb {
            cell.configure(with: imageUrl)
        }*/
        /*if let imageUrl = URL(string: imageUrlString) {
            cell.imgView.load(url: imageUrl)
        }*/
        let item = images[indexPath.row]

        cell.imgView.sd_setImage(with: URL(string: item.urls.small))

        return cell
    }
    
    // MARK: List Item coustom Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.width/3)
        
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
