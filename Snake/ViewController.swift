//
//  ViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit
import CoreData

/*
 * ViewController(.swift) -> main menu, where user can:
 * 1. -> "start game"           -> lead to "GameViewController" in GameViewController.swift
 * 2. -> "view highscores"      -> lead to "HighScoreViewController" in Scores.swift
 * 3. -> "change settings"      -> lead to "SettingsViewController" in Settings.swift
 * 4. -> "show credits"         -> lead to "CreditViewController" in Credits.swift
 * 5. -> close the app
 *
 * ViewController loads old user settings and highscores (use of function "fetchData" from saveNrestore.swift)
 * and put them into gloabl variables (they're in GlobalVariables.swift)
 */

class ViewController: UIViewController {
    
    //stuff for loading old highscores and settings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fetchData(context)  //load old highscores and settings into global variables
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){} //back-buttons from other view controllers will lead to this one
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        exit(0)
    }
}

