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
import QCropper

class ImageViewController: UIViewController {
    var selectedImage: HomeImage?
    var selectedImagee: ItemListDatum?
    var wallpaperAlbum: PHAssetCollection?
    
    @IBOutlet weak var editTap: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var saveBtn: SoftButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cropBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    var cropOverlayView: UIView?
    var croppedImage: UIImage?
    var originalImage: UIImage?
    var cropperState: CropperState?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        imgView.layer.cornerRadius = 20
        backBtn.makeNeuromorphic(cornerRadius: backBtn.bounds.height/2, superView: self.view)
        
        if let selectedImage = selectedImage {
            // Assuming you have an image URL property in HomeImage, update the following line accordingly
            let imageUrl = URL(string: (selectedImage.urls?.full)!)
            //imgView.load(url: imageUrl!)
            imgView.sd_setImage(with: imageUrl)
            
        }else if let selectedImagee = selectedImagee{
            let imageUrl = URL(string: (selectedImagee.urls.full))
            //imgView.load(url: imageUrl!)
            imgView.sd_setImage(with: imageUrl)
            
        }
    }
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func editTap(_ sender: Any) {
        bottomView.isHidden = false

    }
    
    @IBAction func saveTap(_ sender: Any) {
        guard let imageToSave = imgView.image else {
            // Handle the case where there's no image to save
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    
    
    @IBAction func cropTap(_ sender: Any) {
      
        if let imageToCrop = imgView.image {
                let cropper = CropperViewController(originalImage: imageToCrop)
            cropper.delegate = self

                self.present(cropper, animated: true, completion: nil)
            }
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
extension ImageViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)

        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
            cropperState = state
            imgView.image = image
            bottomView.isHidden = true
            print(cropper.isCurrentlyInInitialState)
            print(image)
        }
    }
}
