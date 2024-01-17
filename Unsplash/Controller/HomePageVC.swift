//
//  HomePageVC.swift
//  Unsplash
//
//  Created by CubezyTech on 11/01/24.
//

import UIKit
import SoftButton
import Alamofire
import CHTCollectionViewWaterfallLayout
class HomePageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionBtn: SoftButton!
    @IBOutlet weak var randomBtn: SoftButton!
    @IBOutlet weak var popullarbtn: SoftButton!
    
    var currentOrdering: OrderingCriteria = .latest
    var newPhotos:[HomeImage] = []
    var pageNumber : Int = 0
    var isPageRefreshing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outerView.layer.cornerRadius = 30
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout();
        
        
        collectionPhotos(page: pageNumber, orderby: "latest")
    
        
        collectionBtn.makeNeuromorphic(cornerRadius: collectionBtn.bounds.height/2, superView: self.view)
        randomBtn.makeNeuromorphic(cornerRadius: randomBtn.bounds.height/2, superView: self.view)
        popullarbtn.makeNeuromorphic(cornerRadius: popullarbtn.bounds.height/2, superView: self.view)
        
    }
    
    @IBAction func collectionTap(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "collectionlist") as! CollectionListVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    @IBAction func populattap(_ sender: Any) {
        currentOrdering = .popular
        
        resetDataAndFetch(pageNumber: 0, orderby: "popular")
        collectionView.reloadData()
        
    }
    @IBAction func randomTap(_ sender: Any) {
        currentOrdering = .random
        resetDataAndFetch(pageNumber: 0, orderby: "random")
        collectionView.reloadData()
        
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                pageNumber = pageNumber + 1
                
                // Choose the appropriate API based on the ordering criteria
                switch currentOrdering {
                case .latest:
                    collectionPhotos(page: pageNumber, orderby: "latest")
                case .random:
                    collectionPhotos(page: pageNumber, orderby: "random")
                case .popular:
                    collectionPhotos(page: pageNumber, orderby: "popular")
                }
            }
        }
    }
    func showImageDetailViewController(image: HomeImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageDetailVC = storyboard.instantiateViewController(withIdentifier: "viewImage") as? ImageViewController {
            imageDetailVC.selectedImage = image
            self.navigationController?.pushViewController(imageDetailVC, animated: true)
        }
    }
    private func resetDataAndFetch(pageNumber: Int, orderby: String) {
        newPhotos.removeAll()
        self.pageNumber = pageNumber
        collectionPhotos(page: pageNumber, orderby: orderby)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return newPhotos.count
     }
     //MARK: ImageItem
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionViewCell
         let item = newPhotos[indexPath.row]
         cell.setimages(item: item,isFile:false)
         
         return cell
     }
     
     let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
     let numberOfItemsPerColumn: CGFloat = 3
     let spacingBetweenCells: CGFloat = 15
     
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerColumn - 1) * spacingBetweenCells)
         
         if let collection = self.collectionView {
             let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerColumn
             let height = 150 // Set your desired height here
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
         let selectedImage = newPhotos[indexPath.row]
         showImageDetailViewController(image: selectedImage)
     }
    func collectionPhotos(page:Int, orderby: String) {
        if(newPhotos.isEmpty){
            self.view.showBlurLoader()
        }
        
        let parameters: [String: Any] = [
            "client_id" : AppConst.clinetid,
            "order_by": orderby,
            "page":String(page),
            "per_page":"20"
        ]
        AF.request(AppConst.baseurl+AppConst.photoUrl,method: .get,parameters: parameters).validate().responseDecodable(of: [HomeImage].self) { (response) in
            guard let data = response.value else {
                
                self.view.removeBluerLoader()
                self.isPageRefreshing = false
                return
            }
            
            self.newPhotos.append(contentsOf: data)
            self.collectionView.reloadData()
            self.view.removeBluerLoader()
            self.isPageRefreshing = false
        }
    }
}
