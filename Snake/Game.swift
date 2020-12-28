//
//  Game.swift
//  Snake
//
//  Created by Echo on 27.12.20.
//

import UIKit

class Game {
    var isRunning = true
    var board : Board
    var player : SnakeHead
    var apple : GameObject
    
    init(_ gameWindow : UIView){
        player = SnakeHead(boardPosition: CGPoint.init(x: 13, y: 10), direction: Direction.right)
        apple = GameObject(boardPosition: CGPoint.init(x: 2, y: 2))
        board = Board(gameWindow)
    }
    
    func update(){
        self.player.moveForward()
        self.board.updateMap(self.player, self.apple)
        self.board.updateGraphics(self.player, self.apple)
    }
}
