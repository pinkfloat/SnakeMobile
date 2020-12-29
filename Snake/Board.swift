//
//  Board.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit

enum fieldCondition {
    case empty, apple, snake, wall
}

class Board {
    let pxSize : CGFloat
    let pxFieldSize : CGFloat
    let fields : Int = 20            //means the board got the size 20x20
    lazy var field : [[fieldCondition]] = Array(repeating: Array(repeating: fieldCondition.empty, count: fields), count: fields)
    lazy var graphics : [[UIImageView?]] = Array(repeating: Array(repeating: nil, count: fields), count: fields)
    
    init(_ gameWindow: UIView) {
        pxSize = gameWindow.frame.size.width
        pxFieldSize =  pxSize / CGFloat(fields)
        for line in 0..<fields {
            for row in 0..<fields {
                graphics[line][row] = UIImageView(frame: CGRect(x: CGFloat(row) * pxFieldSize,
                                                                y: CGFloat(line) * pxFieldSize + 50,
                                                                width: pxFieldSize,
                                                                height: pxFieldSize))
                graphics[line][row]?.backgroundColor = .darkGray
                graphics[line][row]!.image = TEmpty.image
                gameWindow.addSubview(graphics[line][row]!)
            }
        }
    }
    
    func updateMap(_ player : SnakeHead,_ apple : GameObject) {
        for line in 1..<fields-1 {
            for row in 1..<fields-1 {
                field[line][row] = fieldCondition.empty
            }
        }
        field[Int(apple.boardPos.y)][Int(apple.boardPos.x)] = fieldCondition.apple
        for part in player.Parts {
            field[Int(part.boardPos.y)][Int(part.boardPos.x)] = fieldCondition.snake
        }
    }
    
    func updateGraphics(_ player : SnakeHead,_ apple : GameObject){
        for line in 1..<fields-1 {
            for row in 1..<fields-1 {
                if field[line][row] == fieldCondition.empty {
                    graphics[line][row]?.image = TEmpty.image;
                }
            }
        }
        graphics[Int(apple.boardPos.y)][Int(apple.boardPos.x)]?.image = apple.imageObj.image
        graphics[Int(player.boardPos.y)][Int(player.boardPos.x)]?.image = player.imageObj.image
        for part in player.Parts {
            graphics[Int(part.boardPos.y)][Int(part.boardPos.x)]?.image = part.imageObj.image
        }
    }
    
    func checkCollision(_ player : SnakeHead,_ apple : GameObject) -> Bool {
        if field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.empty {
            return true
        }
        else if player.Parts.count == fields*fields-1 {
            print("Player won, but no one will ever notice...")
            return false
        }
        else if field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.apple {
            //resize snake
            let newPart = SnakePart(boardPosition: player.boardPos, direction: player.dir!, previousPart: player.Parts.last!)
            player.addSnakePart(newPart)
            replaceApple(player, apple)
            return true
        }
        else if field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.wall {
            print("Player crashes through wall")
            return false
        }
        else if field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.snake {
            print("Player ate himself")
            return false
        }
        else {
           print("Player managed to came to an uninitialized field aka wormhole")
            return false
        }
    }
    
    func replaceApple(_ player : SnakeHead,_ apple : GameObject) {
        
    }
}
