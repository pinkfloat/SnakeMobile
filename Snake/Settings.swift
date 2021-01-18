//
//  Settings.swift
//  Snake
//
//  Created by Echo on 05.01.21.
//


import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    //stuff for saving data like actual settings
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
        
        boardSizeSlider.setValue(Float(global.boardSize), animated: false)
        boardValueLabel.text = "\(global.boardSize) x \(global.boardSize)"
        let showSpeed = 1 / global.gameSpeed
        gameSpeedSlider.setValue(showSpeed, animated: false)
        speedValueLabel.text = String(format: "%.1f", showSpeed)
        soundSwitch.setOn(global.sound, animated: false)
    }
    
    @IBAction func changeBoardSize(_ sender: Any) {
        let size = Int(boardSizeSlider.value)
        global.boardSize = size
        boardValueLabel.text = "\(size) x \(size)"
    }
    
    @IBAction func changeGameSpeed(_ sender: Any) {
        global.gameSpeed = 1 / (round (gameSpeedSlider.value * 10) / 10)
        speedValueLabel.text = String(format: "%.1f", gameSpeedSlider.value)
    }
    
    @IBAction func changeSoundOption(_ sender: Any) {
        global.sound = soundSwitch.isOn
    }
    
    @IBAction func exitSettings(_ sender: UIButton) {
        saveSettings(context)
    }
    
    @IBAction func resetSettings(_ sender: UIButton) {
        boardSizeSlider.setValue(Float(20), animated: false)
        changeBoardSize(sender)
        gameSpeedSlider.setValue(Float(2), animated: false)
        changeGameSpeed(sender)
        soundSwitch.setOn(true, animated: false)
        changeSoundOption(sender)
    }    
}
