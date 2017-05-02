//
//  ViewController.swift
//  RoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapped(_ button: RoundBorderedButton) {
        button.isSelected = !button.isSelected
    }
}

