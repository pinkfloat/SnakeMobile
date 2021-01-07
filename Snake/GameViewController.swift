//
//  GameViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameWindow: UIView!
    lazy var snake = Game(gameWindow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.snake.checkIfHighScore()
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
}
