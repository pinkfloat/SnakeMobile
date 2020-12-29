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
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.snake.isRunning == false {
                timer.invalidate()
            }
            self.snake.update()
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
