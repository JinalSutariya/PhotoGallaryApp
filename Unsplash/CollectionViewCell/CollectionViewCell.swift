//
//  CollectionViewCell.swift
//  Unsplash
//
//  Created by CubezyTech on 06/12/23.
//
import Foundation

import UIKit
import SDWebImage
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    let blur_hash = "LLA,?u%MD*IU~pxuIUIU-;t7RjNF"
    
    override func awakeFromNib() {
        imgView.makeRounded()
        imgView.contentMode = .scaleAspectFill
        
    }
    func setimages(item :HomeImage,isFile :Bool){
        
        imgView.sd_setImage(with: URL(string: item.urls?.small ?? "Defult URL"))
    }
    
    
}
class SearchCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    let blur_hash = "LLA,?u%MD*IU~pxuIUIU-;t7RjNF"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(with imageUrl: String) {
            loadImage(with: imageUrl)
        }

        private func loadImage(with url: String) {
            // Implement the logic to load the image from the URL and set it to imageView
            // Example: You can use AlamofireImage, SDWebImage, or your preferred library.
            imgView.load(url: URL(string: url)!)
        }
    
}

extension UIImageView {
    func makeRounded() {
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
    }
}
class CollectionlistViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
    }
    
    func configure(with imageUrl: String) {
            loadImage(with: imageUrl)
        }

        private func loadImage(with url: String) {
            // Implement the logic to load the image from the URL and set it to imageView
            // Example: You can use AlamofireImage, SDWebImage, or your preferred library.
            imgView.load(url: URL(string: url)!)
        }
}

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
class FavouriteCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
}
