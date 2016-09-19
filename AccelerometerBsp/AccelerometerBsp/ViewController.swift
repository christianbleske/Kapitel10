//
//  ViewController.swift
//  AccelerometerBsp
//
//  Created by Christian Bleske on 14.12.14.
//  Copyright (c) 2014 Christian Bleske. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var uiView : UIView?
    var uiDynamicAnimator:UIDynamicAnimator? = nil;
    let uiGravityBehavior = UIGravityBehavior()
    let uiCollisionBehavior = UICollisionBehavior()
    let cmMotionManager = CMMotionManager()
    let nsOperationQueue = OperationQueue()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.green
        addView(CGRect(x: 150, y: 150, width: 50, height: 50))
        initBehavior()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBehavior() {
        uiDynamicAnimator = UIDynamicAnimator(referenceView:self.view);
        
        uiGravityBehavior.addItem(uiView!);
        uiGravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0.8)
        uiDynamicAnimator?.addBehavior(uiGravityBehavior);
        
        uiCollisionBehavior.addItem(uiView!)
        uiCollisionBehavior.translatesReferenceBoundsIntoBoundary = true
        uiDynamicAnimator?.addBehavior(uiCollisionBehavior)
    }
    
    func addView(_ location: CGRect) {
        let newView = UIView(frame: location)
        
        newView.backgroundColor = UIColor.black
        
        view.insertSubview(newView, at: 0)
        uiView = newView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cmMotionManager.startDeviceMotionUpdates(to: nsOperationQueue,
            withHandler: cmAccelerometerHandler as! CMDeviceMotionHandler)
    }

    
    func cmAccelerometerHandler(_ motion: CMDeviceMotion?, error: NSError?) {
        if (error != nil) {
            NSLog("\(error)")
        }
        
        let gravity : CMAcceleration = motion!.gravity
        let x = CGFloat(gravity.x)
        let y = CGFloat(gravity.y)
        let cgPoint = CGPoint(x: x,y: y)
        let v = CGVector(dx: cgPoint.x, dy: 0 - cgPoint.y)
        uiGravityBehavior.gravityDirection = v
    }

    override func viewWillDisappear(_ animated: Bool) {
        cmMotionManager.stopDeviceMotionUpdates()
    }


}

