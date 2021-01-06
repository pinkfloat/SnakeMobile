//
//  Settings.swift
//  Snake
//
//  Created by Echo on 05.01.21.
//

import UIKit

struct globalSettings {
    var boardSize : Int = 20
    var gameSpeed : Float = 0.5
    var sound = true
}

var global = globalSettings()

class SettingsViewController: UIViewController {
    @IBOutlet weak var boardSizeSlider: UISlider!
    @IBOutlet weak var boardValueLabel: UILabel!
    @IBOutlet weak var gameSpeedSlider: UISlider!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
