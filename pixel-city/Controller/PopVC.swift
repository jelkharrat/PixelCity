//
//  PopVC.swift
//  pixel-city
//
//  Created by Nessin Elkharrat on 3/28/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    //Outlets
    @IBOutlet weak var popImageView: UIImageView!
    
    //Variables
    var passedImage: UIImage!
    
    //passing in an image from collection view cell
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
        addDoubleTap()
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
         view.addGestureRecognizer(doubleTap)
    }

    
    @objc func screenWasDoubleTapped() {
        //dismisses view controller
        dismiss(animated: true, completion: nil)
    }
    
}
