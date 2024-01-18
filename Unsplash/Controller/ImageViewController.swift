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
import CoreImage
import SQLite

class ImageViewController: UIViewController {

    
    
   
    
   
    
    @IBOutlet weak var filter1: UIButton!
    @IBOutlet weak var filter2: UIButton!
    @IBOutlet weak var filter3: UIButton!
    @IBOutlet weak var filter4: UIButton!
    @IBOutlet weak var filter5: UIButton!
    @IBOutlet weak var filter6: UIButton!
    @IBOutlet weak var sliderView: UISlider!
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
    var editorImageListArray = [UIImage]()
    var favoritePhotos: [UIImage] = []
    var selectedImage: HomeImage?
    var selectedImagee: ItemListDatum?
    var wallpaperAlbum: PHAssetCollection?
    var productID: String?
    var favImage: UIImage?
    var saveeImage: UIImage?
    var searchImage: Resulttt?
   

   
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
        favBtn.addTarget(self, action: #selector(tapFav), for: .touchUpInside)
        
        if let selectedImage = selectedImage {
            let imageUrl = URL(string: (selectedImage.urls?.full)!)
            imgView.sd_setImage(with: imageUrl)
            
        }else if let selectedImagee = selectedImagee{
            let imageUrl = URL(string: (selectedImagee.urls.full))
            imgView.sd_setImage(with: imageUrl)
            
        }else if let favImage = favImage{
            imgView.image = favImage
            
        }else if let saveImage = saveeImage{
            imgView.image = saveeImage
        }else if let searchImage = searchImage{
            let imageUrl = URL(string: (searchImage.urls.full))
            imgView.sd_setImage(with: imageUrl)
        }
    }
   
    @objc func tapFav() {
        if let image = imgView.image {
            if let imageData = image.pngData() {
                let isFavorited = InsertDatabaseHelper.shared.isImageInFavorites(imageData: imageData)

                if isFavorited {
                    // Image is already in favorites, remove it
                    InsertDatabaseHelper.shared.removeImageFromFavorites(imageData: imageData)
                    setFavBtnImage(isFavorited: false)
                    showAlert(message: "Image removed from favorites.")
                } else {
                    // Image is not in favorites, add it
                    InsertDatabaseHelper.shared.insertImage(imageData: imageData)
                    setFavBtnImage(isFavorited: true)
                    showAlert(message: "Image added to favorites.")
                }
            } else {
                showAlert(message: "Failed to add/remove image to/from favorites.")
            }
        }
    }
    
    
   
    func setFavBtnImage(isFavorited: Bool) {
        // Update the icon of favBtn based on the current state
        let iconName = isFavorited ? "Vector" : "Favourite"
        let newIcon = UIImage(named: iconName)
        let newImageView = UIImageView(image: newIcon)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        favBtn.setContentView(newImageView)
        newImageView.centerXAnchor.constraint(equalTo: favBtn.centerXAnchor).isActive = true
        newImageView.centerYAnchor.constraint(equalTo: favBtn.centerYAnchor).isActive = true
        
        favBtn.isSelected = isFavorited
    }
    
   
   

    
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func brightnessTap(_ sender: Any) {

    }
    @IBAction func changeBrightness(_ sender: UISlider) {
 
       
        updateImageBrightness(brightness: sender.value)
           }

           func updateImageBrightness(brightness: Float) {
               if let originalImage = imgView.image {
                   let context = CIContext(options: nil)
                   if let ciImage = CIImage(image: originalImage) {
                       let filter = CIFilter(name: "CIColorControls")
                       filter?.setValue(ciImage, forKey: kCIInputImageKey)
                       filter?.setValue(brightness, forKey: kCIInputBrightnessKey)

                       if let outputImage = filter?.outputImage,
                          let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                           let processedImage = UIImage(cgImage: cgImage)
                           imgView.image = processedImage
                       }
                   }
               }
           }
    @IBAction func contrastButtonTapped(_ sender: UIButton) {

    }
    @IBAction func moreTap(_ sender: Any) {
        if #available(iOS 9.0, *) {
            let imageAdjustView = ImageAdjustView.create(image : self.imgView.image!)
            imageAdjustView.selectSaveImageCallback = { image in
                self.setframeImageUI(image : image , isChanges : true)
            }
        }
    }
    
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Wishlist", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    func setframeImageUI(image : UIImage , isChanges : Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
            UIView.animate(withDuration: 0.30, animations:  {
                self.imgView.image = image
                if isChanges{
                    self.editorImageListArray.append(image)
                }
            }, completion: { finished in
            })
        }
    }
    
    @objc func saveImage() {
        guard let imageToSave = imgView.image else {
                                         return
        }
        if let image = imgView.image {
            if let imageData = image.pngData() {
                let isFavorited = SaveDatabaseHelper.shared.isImageInSave(imageData: imageData)

                if isFavorited {
                    // Image is already in favorites, remove it
                    showAlert(message: "Image removed from download.")
                } else {
                    // Image is not in favorites, add it
                    SaveDatabaseHelper.shared.saveImage(imageData: imageData)
                    showAlert(message: "Image added to downlod.")
                }
            } else {
                showAlert(message: "Failed to add/remove image to/from download.")
            }
        }
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func cropImage() {
        if let imageToCrop = imgView.image {
            let cropper = CropperViewController(originalImage: imageToCrop)
            cropper.delegate = self
            
            self.present(cropper, animated: true, completion: nil)
        }
    }
    @objc func homeTap() {
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func adjustImage() {
        adjustview.isHidden = !adjustview.isHidden
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the save error
            print("Error saving image: \(error.localizedDescription)")
        } else {
            displaySuccess(message: "Image saved successfully.")
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
        homeBtn.addTarget(self, action: #selector(homeTap), for: .touchDown)
        
        
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
    private func displaySuccess(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
