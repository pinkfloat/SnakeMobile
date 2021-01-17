//
//  GameViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//
//  used source for storing and fetching data:
//  https://stackoverflow.com/questions/25586593/coredata-swift-how-to-save-and-load-data

import UIKit
import CoreData

class GameViewController: UIViewController {
    @IBOutlet weak var gameWindow: UIView!
    var newHighScorePosition : Int? = nil   //if the player got a new highscore, it's index in the highscore-array is here
    var playerName : String = "unknown"     //needed for the highscore table
    
    //stuff for saving data like new highscores and corresponding player name
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    //the game class handles the game logic
    lazy var snake = Game(gameWindow)
    
    //stuff that's shown when game has ended, let's call it "game ended stuff"
    @IBOutlet weak var textFieldInfoLabel: UILabel!
    @IBOutlet weak var textfieldForUserName: UITextField!
    @IBOutlet weak var replayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        hideGameEndedStuff()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startGame()
    }
    
    private func startGame() {
        sleep(1)
        //Repeat game logic until the game ended...
        Timer.scheduledTimer(withTimeInterval: TimeInterval(global.gameSpeed), repeats: true) { timer in
            if self.snake.isRunning == false {
                timer.invalidate()
                //When the game ends, show the player an alert message why
                if (self.snake.alert != nil) && (self.presentedViewController == nil) {
                    self.present(self.snake.alert!, animated: false){
                        sleep(5)
                        self.dismiss(animated: false, completion: nil)
                    }
                    //If the player got a new highscore: ask for his name and save it
                    self.newHighScorePosition = self.snake.checkIfHighScore(self.playerName)
                    if self.newHighScorePosition != nil {
                        self.textFieldInfoLabel.isHidden = false
                        self.textfieldForUserName.isHidden = false
                        self.gameWindow.bringSubviewToFront(self.textFieldInfoLabel)
                        self.gameWindow.bringSubviewToFront(self.textfieldForUserName)
                        self.saveData()
                    }
                }
                //show replay button
                self.replayButton.isHidden = false
                self.gameWindow.bringSubviewToFront(self.replayButton)
            }
            //If game didn't end: repeat game logic
            else {
                self.snake.update()
            }
        }
    }
    
    //Receiving D-Pad signals
    @IBAction func moveUp(_ sender: UIButton) {
        snake.player.changeDirUp()
    }
    @IBAction func moveRight(_ sender: UIButton) {
        snake.player.changeDirRight()
    }
    @IBAction func moveDown(_ sender: UIButton) {
        snake.player.changeDirDown()
    }
    @IBAction func moveLeft(_ sender: UIButton) {
        snake.player.changeDirLeft()
    }
    
    private func hideGameEndedStuff() {
        textFieldInfoLabel.text = "New Highscore! Your Name?"
        textFieldInfoLabel.isHidden = true
        textfieldForUserName.isHidden = true
        replayButton.isHidden = true
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        hideGameEndedStuff()
        snake.reset()
        startGame()
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
                    textFieldInfoLabel.text = "New Highscore! Your Name?"
                    playerName = sender.text!
                }
                else {
                    textFieldInfoLabel.text = "Max 10 characters!"
                }
            }
            else {
                playerName = "unknown"
            }
            //update the correct player name on highscore table
            globalHighScoreNames[newHighScorePosition!] = playerName
            self.saveData()
        }
    }
    
//___FUNCTIONS_FOR_SAVING_HIGHSCORES___
    
    private func saveHighscores(_ data: NSManagedObject){
        for idx in 0..<10 {
            data.setValue(globalHighScores[idx], forKey: "score\(idx+1)")
        }
    }
    
    private func saveHighscoreNames(_ data: NSManagedObject){
        for idx in 0..<10 {
            data.setValue(globalHighScoreNames[idx], forKey: "name\(idx+1)")
        }
    }
    
    private func saveDataInModel(entityName: String,
                                  saveFunction: (NSManagedObject) -> Void)
    {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let data = NSManagedObject(entity: entity!, insertInto: context)
        saveFunction(data)
        do {
            try context.save()
        } catch {
            print("Storing Data Failed!")
        }
    }
    
    private func saveData() {
        print("Storing Data..")
        saveDataInModel(entityName: "Highscores", saveFunction: saveHighscores(_:))
        saveDataInModel(entityName: "HighscoreUsers", saveFunction: saveHighscoreNames(_:))
    }
}
