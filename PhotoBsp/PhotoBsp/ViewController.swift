//
//  ViewController.swift
//  PhotoBsp
//
//  Created by Christian Bleske on 17.02.15.
//  Copyright (c) 2015 Christian Bleske. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var uiImageView: UIImageView!
    
    var uiImagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnTakePhoto_Pressed(_ sender: AnyObject) {
        uiImagePickerController =  UIImagePickerController()
        uiImagePickerController.delegate = self
        uiImagePickerController.sourceType = .camera
        
        present(uiImagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        uiImagePickerController.dismiss(animated: true, completion: nil)
        uiImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}

