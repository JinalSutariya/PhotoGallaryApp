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
    }
    func setimages(item :HomeImage,isFile :Bool){
        let height = item.height! / 120
        let width = item.width! / 120
        let hash = item.blur_hash ?? blur_hash
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
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
