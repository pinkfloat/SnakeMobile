//
//  GameViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//


import UIKit
import CoreData

/*
 * This viewcontroller shows the snake game and keep it running
 * however: since it's just a viewcontroller, it mainly manage gui stuff
 * to let the user interact with the game
 * you can find the backend-class "Game" in Game.swift
*/

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
    
    //the "main-function" of the snake game itself
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
                        saveHighscoreData(self.context)
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
            saveHighscoreData(self.context)
        }
    }
}
