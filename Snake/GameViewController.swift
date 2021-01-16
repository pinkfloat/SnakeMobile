//
//  GameViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
    @IBOutlet weak var gameWindow: UIView!
    @IBOutlet weak var textFieldInfoLabel: UILabel!
    @IBOutlet weak var textfieldForUserName: UITextField!
    var newHighScorePosition : Int? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    lazy var snake = Game(gameWindow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        textFieldInfoLabel.text = "New Highscore! Your Name?"
        textFieldInfoLabel.isHidden = true
        textfieldForUserName.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sleep(1)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(global.gameSpeed), repeats: true) { timer in
            if self.snake.isRunning == false {
                timer.invalidate()
                if (self.snake.alert != nil) {
                    self.present(self.snake.alert!, animated: true){
                        sleep(5)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                self.newHighScorePosition = self.snake.checkIfHighScore()
                if self.newHighScorePosition != nil {
                    self.textFieldInfoLabel.isHidden = false
                    self.textfieldForUserName.isHidden = false
                    self.gameWindow.bringSubviewToFront(self.textFieldInfoLabel)
                    self.gameWindow.bringSubviewToFront(self.textfieldForUserName)
                    self.saveData()
                }
            }
            else {
                self.snake.update()
            }
        }
    }
    @IBAction func moveUp(_ sender: Any) {
        snake.player.changeDirUp()
    }
    @IBAction func moveRight(_ sender: Any) {
        snake.player.changeDirRight()
    }
    @IBAction func moveDown(_ sender: Any) {
        snake.player.changeDirDown()
    }
    @IBAction func moveLeft(_ sender: Any) {
        snake.player.changeDirLeft()
    }
    @IBAction func endGame(_ sender: UIButton) {
        self.snake.isRunning = false
    }
    @IBAction func updateHighScoreFromTextField(_ sender: UITextField) {
        if newHighScorePosition != nil {
            //save textfield content if not empty
            if sender.text != nil && sender.text != "" {
                //the user name shouldn't be longer than 10 chars
                if sender.text!.count <= 10 {
                    globalHighScoreNames[newHighScorePosition!] = sender.text!
                }
                else {
                    textFieldInfoLabel.text = "Max 10 characters!"
                }
            }
            else {
                globalHighScoreNames[newHighScorePosition!] = "unknown"
            }
            self.saveData()
        }
    }
    private func saveData() {
        print("Storing Data..")
        var entity = NSEntityDescription.entity(forEntityName: "Highscores", in: context)
        let actualHighScore = NSManagedObject(entity: entity!, insertInto: context)
        for idx in 0..<10 {
            actualHighScore.setValue(globalHighScores[idx], forKey: "score\(idx+1)")
        }
        do {
            try context.save()
        } catch {
            print("Storing Highscore Data Failed")
        }
        
        entity = NSEntityDescription.entity(forEntityName: "HighscoreUsers", in: context)
        let actualName = NSManagedObject(entity: entity!, insertInto: context)
        for idx in 0..<10 {
            actualName.setValue(globalHighScoreNames[idx], forKey: "name\(idx+1)")
        }
        do {
            try context.save()
        } catch {
            print("Storing User Names Failed")
        }
        
    }
}
