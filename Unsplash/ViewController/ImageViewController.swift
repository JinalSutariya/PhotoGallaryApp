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
    

    @IBOutlet weak var filter1: UIButton!
    @IBOutlet weak var filter2: UIButton!
    @IBOutlet weak var filter3: UIButton!
    @IBOutlet weak var filter4: UIButton!
    @IBOutlet weak var filter5: UIButton!
    
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var filter6: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomView: SoftUIView!
    
    @IBOutlet weak var backBtn: SoftButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var homeBtn: SoftUIView!
    @IBOutlet weak var adjustBtn: SoftUIView!
    @IBOutlet weak var favBtn: SoftUIView!
    @IBOutlet weak var cropBtn: SoftUIView!
    @IBOutlet weak var saveBtn: SoftUIView!
    @IBOutlet weak var adjustview: SoftUIView!
                      
    var cropOverlayView: UIView?
    var croppedImage: UIImage?
    var originalImage: UIImage?
    var cropperState: CropperState?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubtitleView() 
        setupForwardView()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        adjustview.addSubview(stackView)
        adjustview.addSubview(sliderView)
        adjustview.isHidden = true
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
   
    
    @objc func saveImage() {
        guard let imageToSave = imgView.image else {
            // Handle the case where there's no image to save
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)    }
    @objc func cropImage() {
        if let imageToCrop = imgView.image {
            let cropper = CropperViewController(originalImage: imageToCrop)
            cropper.delegate = self
            
            self.present(cropper, animated: true, completion: nil)
        }
    }
    @objc func adjustImage() {
        adjustview.isHidden = !adjustview.isHidden
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
   
    func setupSubtitleView() {
        bottomView.type = .normal
        bottomView.isSelected = true
        
        adjustview.type = .normal
        adjustview.isSelected = true
        
    }
    func setupForwardView() {
        homeBtn.type = .toggleButton
        homeBtn.cornerRadius = homeBtn.frame.size.width/2
        let icon = UIImage(named: "Home")
        let imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        homeBtn.setContentView(imageView)
        imageView.centerXAnchor.constraint(equalTo: homeBtn.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: homeBtn.centerYAnchor).isActive = true
        
      
        
        favBtn.type = .toggleButton
        favBtn.cornerRadius = favBtn.frame.size.width/2
        let icon2 = UIImage(named: "Favourite")
        let imageView2 = UIImageView(image: icon2)
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        favBtn.setContentView(imageView2)
        imageView2.centerXAnchor.constraint(equalTo: favBtn.centerXAnchor).isActive = true
        imageView2.centerYAnchor.constraint(equalTo: favBtn.centerYAnchor).isActive = true
        
        
        saveBtn.type = .toggleButton
        saveBtn.cornerRadius = saveBtn.frame.size.width/2
        let icon3 = UIImage(named: "Save")
        let imageView3 = UIImageView(image: icon3)
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.setContentView(imageView3)
        imageView3.centerXAnchor.constraint(equalTo: saveBtn.centerXAnchor).isActive = true
        imageView3.centerYAnchor.constraint(equalTo: saveBtn.centerYAnchor).isActive = true
        saveBtn.addTarget(self, action: #selector(saveImage), for: .touchDown)
        
        adjustBtn.type = .toggleButton
        adjustBtn.cornerRadius = adjustBtn.frame.size.width/2
        let icon4 = UIImage(named: "Adjust")
        let imageView4 = UIImageView(image: icon4)
        imageView4.translatesAutoresizingMaskIntoConstraints = false
        adjustBtn.setContentView(imageView4)
        imageView4.centerXAnchor.constraint(equalTo: adjustBtn.centerXAnchor).isActive = true
        imageView4.centerYAnchor.constraint(equalTo: adjustBtn.centerYAnchor).isActive = true
        adjustBtn.addTarget(self, action: #selector(adjustImage), for: .touchDown)

        
        cropBtn.type = .toggleButton
        cropBtn.cornerRadius = cropBtn.frame.size.width/2
        let icon5 = UIImage(named: "Crop")
        let imageView5 = UIImageView(image: icon5)
        imageView5.translatesAutoresizingMaskIntoConstraints = false
        cropBtn.setContentView(imageView5)
        imageView5.centerXAnchor.constraint(equalTo: cropBtn.centerXAnchor).isActive = true
        imageView5.centerYAnchor.constraint(equalTo: cropBtn.centerYAnchor).isActive = true
        cropBtn.addTarget(self, action: #selector(cropImage), for: .touchDown)

       
      
      
     
    }
}
extension ImageViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            cropperState = state
            imgView.image = image
            print(cropper.isCurrentlyInInitialState)
            print(image)
        }
    }
}
