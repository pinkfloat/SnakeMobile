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
        self.board.replaceApple(apple)
        
        appleCounterLabel = AppleCounterLabel(frame: CGRect(x: board.pxSize-70, y: 0, width: 70, height: 30))
        gameWindow.addSubview(appleCounterLabel)
    }
    
    private func checkCollision() -> Bool {
        if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.empty {
            return true
        }
        else if player.Parts.count == board.fields*board.fields-1 {
            print("Player won, but no one will ever notice...")
            return false
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.apple {
            appleCounterLabel.countUp()
            //resize snake
            let newPart = SnakePart(boardPosition: player.boardPos, direction: player.dir!, previousPart: player.Parts.last!)
            player.addSnakePart(newPart)
            board.replaceApple(apple)
            return true
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.wall {
            print("Player crashes through wall")
            return false
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.snake {
            print("Player ate himself")
            return false
        }
        else {
           print("Player managed to came to an uninitialized field aka wormhole")
            return false
        }
    }
    
    func update() {
        self.player.moveForward()
        self.board.updateMap(self.player, self.apple)
        self.board.updateGraphics(self.player, self.apple)
        isRunning = checkCollision()
    }
}
