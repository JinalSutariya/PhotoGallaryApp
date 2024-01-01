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
    
    var images: [UnsplashPhoto] = []
    var pageNumber : Int = 0
    var isPageRefreshing : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout();
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
        
        searchTxt.delegate = self
        
        searchImages(page: pageNumber)
        
    }
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(self.collectionview.contentOffset.y >= (self.collectionview.contentSize.height - self.collectionview.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                pageNumber = pageNumber + 1
                searchImages(page: pageNumber)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pageNumber = 1
        searchImages(page: pageNumber)
        return true
    }
    func searchImages(page: Int) {
        // Replace "YOUR_ACCESS_KEY" with your Unsplash access key
        let accessKey = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"
        
        guard let query = searchTxt.text, !query.isEmpty else {
            print("Empty query, not performing search.")
            return
        }
        
        let urlString = "https://api.unsplash.com/photos/?client_id=\(accessKey)&page=\(page)&order_by=\(query)&per_page=20"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(UnsplashSearchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.images = result.results
                    self.collectionview.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SearchCollectionView
        let imageUrlString = images[indexPath.item].urls.regular
        if let imageUrl = URL(string: imageUrlString) {
            cell.imgView.load(url: imageUrl)
        }
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
