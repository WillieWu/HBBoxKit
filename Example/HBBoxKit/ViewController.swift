//
//  ViewController.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 01/02/2019.
//  Copyright (c) 2019 伍宏彬. All rights reserved.
//

import UIKit
import HBBoxKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("\(HBTools.hb_formatMoney(withMoneyString: "10000"))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

