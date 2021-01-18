//
//  ViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //stuff for loading old highscores and settings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fetchData(context)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){}
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        exit(0)
    }
}

