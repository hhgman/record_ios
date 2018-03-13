//
//  SecondaryViewController.swift
//  renewvoicerecord
//
//  Created by JoYH on 2018. 2. 7..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {
    
    
    var text:String = ""
    
    @IBOutlet weak var textLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel?.text = text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
