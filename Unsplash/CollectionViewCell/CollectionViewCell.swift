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
    
    func setimages(item :Result,isFile :Bool){
        
        imgView.sd_setImage(with: URL(string: item.coverPhoto.urls.thumb ?? "Defult URL"))
    }
}

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
