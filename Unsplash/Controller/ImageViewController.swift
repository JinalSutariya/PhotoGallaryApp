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
    
    
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var bottomView: SoftUIView!
    @IBOutlet weak var backBtn: SoftButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var homeBtn: SoftUIView!
    @IBOutlet weak var adjustBtn: SoftUIView!
    @IBOutlet weak var favBtn: SoftUIView!
    @IBOutlet weak var cropBtn: SoftUIView!
    @IBOutlet weak var saveBtn: SoftUIView!
    @IBOutlet weak var adjustview: SoftUIView!
    @IBOutlet weak var layoutStackView: UIStackView!
    
    
    var cropOverlayView: UIView?
    var originalImage: UIImage?
    var cropperState: CropperState?
    var editorImageListArray = [UIImage]()
    var favoritePhotos: [UIImage] = []
    var selectedImage: HomeImage?
    var selectedImagee: ItemListDatum?
    var productID: String?
    var favImage: UIImage?
    var saveeImage: UIImage?
    var searchImage: Resulttt?
    var selectedShade : Shades?
    var viewFrame : CGRect!
    var tempImage : UIImage!
    var selectSaveImageCallback : ((UIImage) -> Void)?
    var selectCancleImageCallback : ((Bool) -> Void)?
    var brightnessValue : CGFloat = 0
    var saturationVlue : CGFloat = 1.0
    var contrastValue : CGFloat = 1.0
    var warmthValue : CGFloat = 157.67
    var vibranceValue : CGFloat = 0.0
    var fadeValue : CGFloat = 0.0
    
    var shadesArray = [Shades.Brightness, Shades.Saturation, Shades.Contrast, Shades.Warmth, Shades.Vibrance, Shades.Fade]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllData()
        setupSubtitleView()
        setupForwardView()
        self.sliderView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        adjustview.addSubview(layoutStackView)
        adjustview.addSubview(sliderView)
        adjustview.isHidden = true
        sliderView.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
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
    @objc func sliderValueChanged() {
        let sliderValue = sliderView.value
        setSliderValue(float: sliderValue)
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
    
    
    func setSliderValue(float: Float) {
        if self.selectedShade == .Brightness {
            let ciContext = CIContext(options: nil)
            brightnessValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputBrightnessKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.imgView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Saturation {
            let ciContext = CIContext(options: nil)
            saturationVlue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputSaturationKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.imgView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Contrast {
            let ciContext = CIContext(options: nil)
            contrastValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputContrastKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.imgView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Warmth {
            let ciContext = CIContext(options: nil)
            warmthValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            var number = CGFloat(float)
            if number > 157.9 {
                let minus = 172 - number
                number = 165 + minus
            } else {
                let minus = 157.9 - number
                number = 130 + minus
            }
            
            let vector0 = CIVector(x: 4000, y: number)
            let vector1 = CIVector(x: 5000, y: number)
            
            let filter = CIFilter(name: "CITemperatureAndTint")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            filter?.setValue(vector0, forKey: "inputNeutral")
            filter?.setValue(vector1, forKey: "inputTargetNeutral")
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.imgView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        
        if self.selectedShade == .Vibrance {
            let ciContext = CIContext(options: nil)
            vibranceValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            let filter = CIFilter(name: "CIVibrance")
            filter?.setValue(float, forKey: "inputAmount")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.imgView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Fade {
            let ciContext = CIContext(options: nil)
            fadeValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if let cgImage = imgView.image?.cgImage {
                coreImage = CIImage(cgImage: cgImage)
            } else if let ciImage = imgView.image?.ciImage {
                coreImage = ciImage
            } else {
                print("No valid image data found.")
                return
            }
            
            let filter = CIFilter(name: "CIPhotoEffectFade")
            filter?.setValue(float, forKey: "inputImage")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                let image = UIImage(cgImage: cgimgresult!)
                let filter = CIFilter(name: "CIHighlightShadowAdjust")
                filter?.setValue(float, forKey: "inputShadowAmount")
                filter?.setValue(CIImage(cgImage: image.cgImage!), forKey: kCIInputImageKey)
                if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage
                {
                    let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                    self.imgView.image = UIImage(cgImage: cgimgresult!)
                }
            } else {
                print("image filtering failed")
            }
        }
    }
    
    
    func setSlider(effecName : Shades) {
        self.sliderView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.imgView.image = imgView.image
        UIView.animate(withDuration: 0.35) {
            self.sliderView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            if effecName == .Brightness {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = -0.5
                self.sliderView.maximumValue = 0.5
                self.sliderView.value = Float(self.brightnessValue)
                self.selectedShade = .Brightness
                self.setSliderValue(float : Float(self.brightnessValue))
            }
            if effecName == .Saturation {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = 0
                self.sliderView.maximumValue = 2
                self.sliderView.value = Float(self.saturationVlue)
                self.selectedShade = .Saturation
                self.setSliderValue(float : Float(self.saturationVlue))
            }
            if effecName == .Contrast {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = 0.5
                self.sliderView.maximumValue = 1.5
                self.sliderView.value = Float(self.contrastValue)
                self.selectedShade = .Contrast
                self.setSliderValue(float : Float(self.contrastValue))
            }
            if effecName == .Warmth {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = 145
                self.sliderView.maximumValue = 172
                self.sliderView.value = Float(self.warmthValue)
                self.selectedShade = .Warmth
                self.setSliderValue(float : Float(self.warmthValue))
            }
            if effecName == .Vibrance {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = -1
                self.sliderView.maximumValue = 1
                self.sliderView.value = Float(self.vibranceValue)
                self.selectedShade = .Vibrance
                self.setSliderValue(float : Float(self.vibranceValue))
            }
            if effecName == .Fade {
                self.sliderView.isHidden = false
                self.sliderView.minimumValue = -1
                self.sliderView.maximumValue = 1
                self.sliderView.value = Float(self.fadeValue)
                self.selectedShade = .Fade
                self.setSliderValue(float : Float(self.fadeValue))
            }
            self.imgView.image = self.imgView.image
            
        }
    }
    
    
    func setFavBtnImage(isFavorited: Bool) {
        
        let iconName = isFavorited ? "Vector" : "Favourite"
        let newIcon = UIImage(named: iconName)
        let newImageView = UIImageView(image: newIcon)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        favBtn.setContentView(newImageView)
        newImageView.centerXAnchor.constraint(equalTo: favBtn.centerXAnchor).isActive = true
        newImageView.centerYAnchor.constraint(equalTo: favBtn.centerYAnchor).isActive = true
        
        favBtn.isSelected = isFavorited
    }
    
    func setAllData() {
        UIView.animate(withDuration: 0.35, animations:  {
            self.imgView.image = self.imgView.image
            self.tempImage = self.imgView.image
            
        }, completion: { finished in
            self.setEffecList()
        })
        
    }
    
    func setEffecList() {
        var count = -1
        for layoutData in self.shadesArray {
            count += 1
            let layoutView = AdjustImageView.create(frame : CGRect(x: 0, y: 0, width: self.layoutStackView.getHeight , height: self.layoutStackView.getHeight), effectCase: layoutData)
            layoutView.tag = count
            layoutView.frame = CGRect(x: 0, y: 0, width: self.layoutStackView.getHeight , height: self.layoutStackView.getHeight)
            layoutView.selectEffectCallback = { effect in
                self.setSlider(effecName : effect)
            }
            self.layoutStackView.addArrangedSubview(layoutView)
            layoutView.setLayoutView()
        }
        
    }
    
    
    
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changeBrightness(_ sender: UISlider) {
        
            self.setSliderValue(float : sender.value)
       
        
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
