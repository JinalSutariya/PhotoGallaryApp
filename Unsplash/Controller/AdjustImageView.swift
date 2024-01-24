//
//  AdjustImageView.swift
//  Flippy
//
//  Created by Infyom on 05/08/17.
//  Copyright © 2017 Infyom. All rights reserved.
//

import UIKit

class AdjustImageView : UIView {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var scaleView: UIView!
    
    var selectEffectCallback : ((Shades) -> Void)?
    
    var viewFrame : CGRect!
    
    var effecString : Shades!
    
    var effectArray = ["Brightness", "Saturation", "Contrast", "Warmth", "Vibrance", "Fade"]
    
    static func create(frame : CGRect ,effectCase : Shades ) -> AdjustImageView {
        let selectView =  Bundle.main.loadNibNamed("AdjustImageView", owner: self, options: nil)?[0] as! AdjustImageView
        selectView.viewFrame = frame
        selectView.effecString = effectCase
        selectView.didInit()
        
        return selectView
    }
    
    func didInit() {
        self.frame = self.viewFrame
    }
    
    func setLayoutView() {
        self.iconImage.image = UIImage(named : "\(getEffecString(name: effecString))")
        self.setDefaultView()
    }
    
    func getEffecString(name: Shades) -> String {
        if name == .Brightness{
            return "filter1"
        }
        if name == .Saturation{
            return "filter2"
        }
        if name == .Contrast{
            return "filter3"
        }
        
        if name == .Warmth{
            return "filter4"
        }
        
        if name == .Vibrance{
            return "filter5"
        }
       
        if name == .Fade{
            return "filter6"
        }
        return ""
    }
    
    func setDefaultView() {
        UIView.animate(withDuration: 0.35){
            self.iconImage.tintColor = UIColor.lightGray.withAlphaComponent(0.8)
            self.scaleView.transform = .identity
        }
    }
    
    @IBAction func onEffectClick(_ sender: Any) {
        for view in (self.superview?.subviews)!{
            if let View = view as? AdjustImageView {
                View.setDefaultView()
            }
        }
        self.iconImage.tintColor = UIColor.white
        self.selectEffectCallback!(effecString)
        if let View = self.superview as? UIStackView {
            if let view = View.superview as? UIScrollView {
                UIView.animate(withDuration: 0.35, animations:  {
                    if view.getWidth < View.getWidth{
                        var position = self.startX - (view.getWidth / 2) +  (self.getWidth / 2) - 5
                        if position + view.getWidth < View.getWidth && position > 0 {
                            view.contentOffset.x = position
                        }else if position < 0 {
                            position = 0
                            view.contentOffset.x = position
                        }else if position + view.getWidth > View.getWidth{
                            position = View.getWidth - view.getWidth
                            view.contentOffset.x = position
                        }
                    }
                    self.scaleView.transform = CGAffineTransform(scaleX: CGFloat(1.2), y: CGFloat(1.2))
                }, completion: { finished in
                })
            }
        }
    }
}

extension UIImage {
    func tintedImage() -> UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
}

public func getScreenHeight() -> CGFloat {
    let screenBound : CGRect = UIScreen.main.bounds
    return screenBound.size.height
}

public func getScreenWidth() -> CGFloat {
    let screenBound : CGRect = UIScreen.main.bounds
    return screenBound.size.width
}
