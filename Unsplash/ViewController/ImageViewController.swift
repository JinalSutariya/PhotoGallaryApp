//
//  ImageViewController.swift
//  Unsplash
//
//  Created by CubezyTech on 12/12/23.
//

import UIKit
import SoftButton
import Photos
import PhotosUI
import TOCropViewController

class ImageViewController: UIViewController {
    var selectedImage: HomeImage?
    var wallpaperAlbum: PHAssetCollection?
    
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var saveBtn: SoftButton!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        imgView.layer.cornerRadius = 20
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
        
        if let selectedImage = selectedImage {
            // Assuming you have an image URL property in HomeImage, update the following line accordingly
            let imageUrl = URL(string: (selectedImage.urls?.full)!)
            //imgView.load(url: imageUrl!)
            imgView.sd_setImage(with: imageUrl)
            
        }
        
        
        
    }
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func saveTap(_ sender: Any) {
        guard let imageToSave = imgView.image else {
            // Handle the case where there's no image to save
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:
                                                                            didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the save error
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Show a success message or perform any other action
            print("Image saved successfully!")
        }
    }
    
}
