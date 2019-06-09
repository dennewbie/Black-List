//
//  InfoViewController.swift
//  BlackList
//
//  Created by Denny Caruso on 21/12/2018.
//  Copyright © 2018 Denny Caruso. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var imgMail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    
    func setImage(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //imgMail.isUserInteractionEnabled = true
        imgMail.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if let url = NSURL(string: "https://goo.gl/forms/EWypyWPjMOSoKIpo1") {
            UIApplication.shared.openURL(url as URL)
        }
        
        // Your action
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
