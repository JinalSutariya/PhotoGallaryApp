//
//  OnboardingVCViewController.swift
//  Unsplash
//
//  Created by CubezyTech on 07/12/23.
//

import UIKit
class OnboardingVC: UIViewController {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        descLbl.text = "We make cool wallpaper for you. \nwhich you can enjoy and use for free"
        goBtn.layer.cornerRadius = goBtn.frame.size.height/2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goTap(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! ViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
