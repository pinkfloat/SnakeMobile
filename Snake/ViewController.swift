//
//  ViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
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
    
    private func fetchData() {
        print("Fetching Data..")
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                global.boardSize = data.value(forKey: "boardSize") as! Int
                global.gameSpeed = data.value(forKey: "gameSpeed") as! Float
                global.sound = data.value(forKey: "sound") as! Bool
            }
        } catch {
            print("Fetching data Failed!")
        }
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Highscores")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                for idx in 0..<10 {
                    globalHighScores[idx] = data.value(forKey: "score\(idx+1)") as! Int
                }
            }
        } catch {
            print("Fetching Highscore Data Failed!")
        }
        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighscoreUsers")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                for idx in 0..<10 {
                    globalHighScoreNames[idx] = data.value(forKey: "name\(idx+1)") as! String
                }
            }
        } catch {
            print("Fetching User Names Failed!")
        }
    }
}

