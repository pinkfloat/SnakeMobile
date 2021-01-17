//
//  ViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//
//  used source for storing and fetching data:
//  https://stackoverflow.com/questions/25586593/coredata-swift-how-to-save-and-load-data

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //stuff for loading old highscores and settings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fetchData()
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){}
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        exit(0)
    }
    
//___FUNCTIONS_FOR_LOADING_OLD_HIGHSCORES_AND_SETTINGS___
    
    private func getSettings (_ data: NSManagedObject) {
        global.boardSize = data.value(forKey: "boardSize") as! Int
        global.gameSpeed = data.value(forKey: "gameSpeed") as! Float
        global.sound = data.value(forKey: "sound") as! Bool
    }
    
    private func getHighscores(_ data: NSManagedObject) {
        for idx in 0..<10 {
            globalHighScores[idx] = data.value(forKey: "score\(idx+1)") as! Int
        }
    }
    
    private func getHighscoreNames(_ data: NSManagedObject) {
        for idx in 0..<10 {
            globalHighScoreNames[idx] = data.value(forKey: "name\(idx+1)") as! String
        }
    }
    
    private func getDataFromModel(entityName: String,
                                  getFunction: (NSManagedObject) -> Void)
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                getFunction(data)
            }
        } catch {
            print("Fetching data Failed!")
        }
    }

    private func fetchData() {
        print("Fetching Data..")
        getDataFromModel(entityName: "Settings", getFunction: getSettings(_:))
        getDataFromModel(entityName: "Highscores", getFunction: getHighscores(_:))
        getDataFromModel(entityName: "HighscoreUsers", getFunction: getHighscoreNames(_:))
    }
}

