//
//  ViewController.swift
//  Unsplash
//
//  Created by CubezyTech on 06/12/23.
//

import UIKit
import SoftButton
import Alamofire
import CHTCollectionViewWaterfallLayout
enum OrderingCriteria {
    case latest
    case random
    case popular
}
class ViewController: UIViewController, DataLoadDelegate, SaveDataLoadDelegate {
    
    
    
    @IBOutlet weak var savePageView: UIView!
    @IBOutlet weak var favouritePageView: UIView!
    @IBOutlet weak var homePageView: UIView!
    
    
    @IBOutlet weak var moreStackView: UIStackView!
    @IBOutlet weak var moreView: SoftUIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var saveBtn: SoftUIView!
    @IBOutlet weak var favBtn: SoftUIView!
    @IBOutlet weak var homeBtn: SoftUIView!
    @IBOutlet weak var cottomView: SoftUIView!
    @IBOutlet weak var moreBtn: SoftButton!
    @IBOutlet weak var searchBtn: SoftButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupSubtitleView()
        moreView.isHidden = true
        moreView.addSubview(moreStackView)
        
        setupForwardView()
        
        cottomView.addSubview(stackView)
        
        searchBtn.makeNeuromorphic(cornerRadius: searchBtn.bounds.height/2, superView: self.view)
        moreBtn.makeNeuromorphic(cornerRadius: moreBtn.bounds.height/2, superView: self.view)
        
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        homeBtn.addGestureRecognizer(firstTapGesture)
        
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        favBtn.addGestureRecognizer(secondTapGesture)
        
        let thirdTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        saveBtn.addGestureRecognizer(thirdTapGesture)
        
        
        
    }
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        showHideContainers(selectedView: selectedView)
        if selectedView == favBtn {
               // Handle the data loading for FavouritePageView
            loadDataForFavouritePageView()
            
           }else if selectedView == saveBtn {
               // Handle the data loading for FavouritePageView
               loadDataForSavePageView()
            
           }
        
    }
    func loadDataForFavouritePageView() {
           // Notify FavouritePageView to load data
           if let favouritePageView = self.favouritePageView as? FavouritteVC {
               favouritePageView.loadFavoriteImages()
           }
       }
    func loadDataForSavePageView() {
        if let favouritePageView = self.savePageView as? DownloadVC {
            favouritePageView.loadSaveImages()
        }
    }
    // Function to show/hide container views based on the selected view
    func showHideContainers(selectedView: UIView) {
        homePageView.isHidden = selectedView != homeBtn
        favouritePageView.isHidden = selectedView != favBtn
        savePageView.isHidden = selectedView != saveBtn
        
        searchBtn.isHidden = favouritePageView.isHidden || savePageView.isHidden
        
        // Unhide searchBtn when showing homePageView
        if !homePageView.isHidden {
            searchBtn.isHidden = false
        } else {
        }
    }
    
    @IBAction func searchImgtap(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @IBAction func moreBtnTap(_ sender: Any) {
        moreView.isHidden = !moreView.isHidden
        
    }
    
    // MARK: - custome function
    
    func setupSubtitleView() {
        cottomView.type = .normal
        cottomView.isSelected = true
        
        moreView.type = .normal
        moreView.isSelected = true
        
    }
    
    func setupForwardView() {
        homeBtn.type = .toggleButton
        
        favBtn.type = .toggleButton
        
        saveBtn.type = .toggleButton
        
        homeBtn.cornerRadius = homeBtn.frame.size.width/2
        favBtn.cornerRadius = favBtn.frame.size.width/2
        saveBtn.cornerRadius = saveBtn.frame.size.width/2
        
        let icon = UIImage(named: "Home")
        let icon2 = UIImage(named: "Favourite")
        let icon3 = UIImage(named: "Save")
        
        let imageView = UIImageView(image: icon)
        let imageView2 = UIImageView(image: icon2)
        let imageView3 = UIImageView(image: icon3)
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .darkGray
        
        homeBtn.setContentView(imageView)
        imageView.centerXAnchor.constraint(equalTo: homeBtn.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: homeBtn.centerYAnchor).isActive = true
        
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.tintColor = .darkGray
        
        favBtn.setContentView(imageView2)
        imageView2.centerXAnchor.constraint(equalTo: favBtn.centerXAnchor).isActive = true
        imageView2.centerYAnchor.constraint(equalTo: favBtn.centerYAnchor).isActive = true
        
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView3.tintColor = .darkGray
        
        saveBtn.setContentView(imageView3)
        imageView3.centerXAnchor.constraint(equalTo: saveBtn.centerXAnchor).isActive = true
        imageView3.centerYAnchor.constraint(equalTo: saveBtn.centerYAnchor).isActive = true
    }
    
    
}
