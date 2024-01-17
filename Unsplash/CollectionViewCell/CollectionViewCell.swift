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
extension UIImageView {
    func makeRounded() {
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
    }
}
