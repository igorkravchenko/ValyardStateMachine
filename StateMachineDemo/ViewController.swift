//
//  ViewController.swift
//  StateMachineDemo
//
//  Created by Igor Kravchenko on 5/17/16.
//  Copyright © 2016 Igor Kravchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var planesEffect:PlanesEffect?
    var shown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bg = UIImageView(image: UIImage(named: "bg"))
        let bgCenter = CGPointMake((CGRectGetWidth(self.view.bounds) - bg.image!.size.width) / 2.0, (CGRectGetHeight(self.view.bounds) - bg.image!.size.height) / 2.0)
        var bgFrame = bg.frame
        bgFrame.origin = bgCenter
        bg.frame = bgFrame
        self.view.addSubview(bg)
        
        let image = UIImage(named: "img")!
        self.planesEffect = PlanesEffect(obj: UIImageView(image: image ))
        planesEffect?.center = CGPointMake(CGRectGetMidX(self.view.bounds) - image.size.width / 2.0, CGRectGetMidY(self.view.bounds) - image.size.height / 2.0)
        self.view.addSubview(planesEffect!)
        
        let control = UIControl(frame: self.view.bounds)
        self.view.addSubview(control)
        control.addTarget(self, action: #selector(self.handleTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func handleTap(sender:UIControl)
    {
        shown = !shown
        
        if shown
        {
            planesEffect?.show()
        }
        else
        {
            planesEffect?.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

