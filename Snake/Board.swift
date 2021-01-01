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
                if line == 0 || line == fields-1 {
                    field[line][row] = fieldCondition.wall
                    graphics[line][row]?.backgroundColor = .white
                }
                else if row == 0 || row == fields-1 {
                    field[line][row] = fieldCondition.wall
                    graphics[line][row]?.backgroundColor = .white
                }
                else {
                    graphics[line][row]?.backgroundColor = .darkGray
                }
                graphics[line][row]!.image = TEmpty.image
                gameWindow.addSubview(graphics[line][row]!)
            }
        }
    }
    
    func replaceApple(_ apple : GameObject) {
        var foundEmptyField = false
        var testPos : CGPoint
        var count = 0
        while !foundEmptyField {
            //try random position
            testPos = CGPoint(x: Int.random(in: 1..<fields-1), y: Int.random(in: 1..<fields-1))
            if field[Int(testPos.y)][Int(testPos.x)] == fieldCondition.empty {
                apple.boardPos = testPos
                foundEmptyField = true
            }
            //if random positioning took too long, find next empty field
            else if count >= 10 {
                outer: for line in 1..<fields-1 {
                    for row in 1..<fields-1 {
                        if field[line][row] == fieldCondition.empty
                        {
                            apple.boardPos=CGPoint(x: row, y: line)
                            foundEmptyField = true
                            break outer
                        }
                    }
                }
            }
            else {
                count+=1
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
}
