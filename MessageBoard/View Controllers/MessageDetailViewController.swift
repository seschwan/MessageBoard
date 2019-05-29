//
//  MessageDetailViewController.swift
//  MessageBoard
//
//  Created by Seschwan on 5/28/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameTextField:   UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // Actions
    @IBAction func sendBtnPressed(_ sender: UIBarButtonItem) {
    }
    

}
