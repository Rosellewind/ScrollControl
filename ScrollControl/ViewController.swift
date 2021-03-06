//
//  ViewController.swift
//  ScrollControl
//
//  Created by Roselle Tanner on 5/11/17.
//  Copyright © 2017 Roselle Tanner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollControl: ScrollControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollControl.setItems([UILabel(text: "one"), UILabel(text: "two"), UILabel(text: "three"), UILabel(text: "four"), UILabel(text: "five"), UILabel(text: "six"), UILabel(text: "seven"), UILabel(text: "eight")], andSelectIndex: 1)
    }
}

