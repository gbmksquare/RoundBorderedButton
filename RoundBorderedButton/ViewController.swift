//
//  ViewController.swift
//  GBMRoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet fileprivate weak var button1: GBMRoundBorderedButton!
    @IBOutlet fileprivate weak var button2: GBMRoundBorderedButton!
    @IBOutlet fileprivate weak var button3: GBMRoundBorderedButton!
    @IBOutlet fileprivate weak var button4: GBMRoundBorderedButton!
    @IBOutlet fileprivate weak var button5: GBMRoundBorderedButton!
    @IBOutlet fileprivate weak var button6: GBMRoundBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapped(_ button: GBMRoundBorderedButton) {
        button.isSelected = !button.isSelected
    }
}

