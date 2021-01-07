//
//  Settings.swift
//  Snake
//
//  Created by Echo on 05.01.21.
//
//  used source for storing and fetching data:
//  https://stackoverflow.com/questions/25586593/coredata-swift-how-to-save-and-load-data

import UIKit
import CoreData

struct globalSettings {
    var boardSize : Int = 20
    var gameSpeed : Float = 0.5
    var sound = true
}

var global = globalSettings()

class SettingsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var boardSizeSlider: UISlider!
    @IBOutlet weak var boardValueLabel: UILabel!
    @IBOutlet weak var gameSpeedSlider: UISlider!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fetchData()
        
        boardSizeSlider.maximumValue=30
        boardSizeSlider.minimumValue=15
        boardSizeSlider.setValue(Float(global.boardSize), animated: false)
        boardValueLabel.text = "\(global.boardSize) x \(global.boardSize)"
        gameSpeedSlider.maximumValue=3.0
        gameSpeedSlider.minimumValue=1.0
        let showSpeed = 1 / global.gameSpeed
        gameSpeedSlider.setValue(showSpeed, animated: false)
        speedValueLabel.text = String(format: "%.1f", showSpeed)
        soundSwitch.setOn(global.sound, animated: false)
    }
    
    private func fetchData() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
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
    }
    
    private func saveData() {
        let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context)
        let actualSettings = NSManagedObject(entity: entity!, insertInto: context)
        actualSettings.setValue(global.boardSize, forKey: "boardSize")
        actualSettings.setValue(global.gameSpeed, forKey: "gameSpeed")
        actualSettings.setValue(global.sound, forKey: "sound")
        
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing Data Failed")
        }
    }
    
    @IBAction func changeBoardSize(_ sender: UISlider) {
        let size = Int(sender.value)
        global.boardSize = size
        boardValueLabel.text = "\(size) x \(size)"
    }
    @IBAction func changeGameSpeed(_ sender: UISlider) {
        global.gameSpeed = 1 / (round (sender.value * 10) / 10)
        speedValueLabel.text = String(format: "%.1f", sender.value)
    }
    @IBAction func changeSoundOption(_ sender: UISwitch) {
        global.sound = sender.isOn
    }
    @IBAction func exitSettings(_ sender: UIButton) {
        saveData()
    }
}
