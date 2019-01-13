//
//  ViewController.swift
//  bigboychoi
//
//  Created by Matt Wormley on 1/12/19.
//  Copyright © 2019 Matt Wormley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inningLabels:[(top: UILabel, bottom: UILabel)] = []
    
    override func viewDidLoad() {
        for i in 1...9 {
            
            let inningTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            
            let labels = (top: UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25)),
                          bottom: UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25)));
            
            inningTitle.center = CGPoint(x: 80 + i * 26, y: 574)
            inningTitle.textAlignment = .center
            inningTitle.text = String(i)
            self.view.addSubview(inningTitle)
            
            labels.top.center = CGPoint(x: 80 + i * 26, y: 600)
            labels.top.textAlignment = .center
            labels.top.text = "0"
            self.view.addSubview(labels.top)
            
            labels.bottom.center = CGPoint(x: 80 + i * 26, y: 626)
            labels.bottom.textAlignment = .center
            labels.bottom.text = "0"
            self.view.addSubview(labels.bottom)
            
            inningLabels += [labels]
            
        }
        
        inningLabels[3].top.text = "4"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

