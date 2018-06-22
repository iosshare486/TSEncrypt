//
//  ViewController.swift
//  TSEncrypt
//
//  Created by 彩球 on 2018/6/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ss = TS_AES.Endcode_AES_CBC(strToEncode: "aaaaaa", key: "0e83c78e002c4107", iv: "0102030405060708")
        print(ss)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

