//
//  ViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){}
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        exit(0)
    }
}

