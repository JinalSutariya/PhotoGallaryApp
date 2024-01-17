//
//  SaveImageCollectionViewCell.swift
//  Unsplash
//
//  Created by CubezyTech on 12/01/24.
//

import UIKit

class SaveImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeRounded()
    }

}
