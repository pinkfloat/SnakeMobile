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
        player = SnakeHead(boardPosition: CGPoint.init(x: 10, y: 10), direction: Direction.right)
        let part1 = SnakePart(boardPosition: CGPoint.init(x: 9, y: 10), direction: Direction.right, previousPart : player)
        let part2 = SnakePart(boardPosition: CGPoint.init(x: 8, y: 10), direction: Direction.right, previousPart : part1, image: TTailRight)
        player.Parts.append(part1)
        player.Parts.append(part2)
        apple = GameObject(boardPosition: CGPoint.init(x: 13, y: 13))
        board = Board(gameWindow)
        self.board.replaceApple(player, apple)
    }
    
    func update() {
        self.player.moveForward()       //Warning: Game will actually crash if Snake runs outside
        self.player.letPartsFollow()
        self.board.updateMap(self.player, self.apple)
        self.board.updateGraphics(self.player, self.apple)
        isRunning = self.board.checkCollision(self.player, self.apple)
    }
}
