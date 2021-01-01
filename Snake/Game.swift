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
    var appleCounterLabel : AppleCounterLabel
    
    init(_ gameWindow : UIView){
        player = SnakeHead(boardPosition: CGPoint.init(x: 10, y: 10), direction: Direction.right)
        let part1 = SnakePart(boardPosition: CGPoint.init(x: 9, y: 10), direction: Direction.right, previousPart : player)
        let part2 = SnakePart(boardPosition: CGPoint.init(x: 8, y: 10), direction: Direction.right, previousPart : part1, image: TTailRight)
        player.Parts.append(part1)
        player.Parts.append(part2)
        apple = GameObject(boardPosition: CGPoint.init(x: 13, y: 13))
        board = Board(gameWindow)
        appleCounterLabel = AppleCounterLabel(frame: CGRect(x: board.pxSize-70, y: 0, width: 70, height: 30))
        gameWindow.addSubview(appleCounterLabel)
        self.board.replaceApple(apple)
    }
    
    func update() {
        self.player.moveForward()
        self.player.letPartsFollow()
        self.board.updateMap(self.player, self.apple)
        self.board.updateGraphics(self.player, self.apple)
        isRunning = self.board.checkCollision(self.player, self.apple, self.appleCounterLabel)
    }
}
