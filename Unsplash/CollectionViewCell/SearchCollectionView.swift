//
//  SearchCollectionView.swift
//  Unsplash
//
//  Created by CubezyTech on 12/01/24.
//

import UIKit

class SearchCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    let blur_hash = "LLA,?u%MD*IU~pxuIUIU-;t7RjNF"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeRounded()
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
