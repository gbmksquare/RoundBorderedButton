//
//  ViewController.swift
//  RoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: RoundBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedButton(sender: RoundBorderedButton) {
        button.selected = !button.selected
    }
}

