//
//  ViewController.swift
//  RoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet fileprivate weak var button1: RoundBorderedButton!
    @IBOutlet fileprivate weak var button2: RoundBorderedButton!
    @IBOutlet fileprivate weak var button3: RoundBorderedButton!
    @IBOutlet fileprivate weak var button4: RoundBorderedButton!
    @IBOutlet fileprivate weak var button5: RoundBorderedButton!
    @IBOutlet fileprivate weak var button6: RoundBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapped(_ button: RoundBorderedButton) {
        button.isSelected = !button.isSelected
    }
}

