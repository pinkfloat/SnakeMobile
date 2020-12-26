//
//  GameViewController.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameWindow: UIView!
    lazy var board = Board(gameWindow)
    var player = GameObject(boardPosition: CGPoint(x: 0, y: 0), image: THeadRight)
    
    lazy var testView = UIImageView(frame: CGRect(x: 0, y: 0, width: gameWindow.frame.size.width/20, height: gameWindow.frame.size.width/20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initNewGame()
    }
    
    private func initNewGame() {
        //let _ = board
        board.graphics[13][10]?.image = player.imageObj.image
    }
}
