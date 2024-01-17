//
//  FavouriteCollectionViewCell.swift
//  Unsplash
//
//  Created by CubezyTech on 12/01/24.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeRounded()
    }
}
