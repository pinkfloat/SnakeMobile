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

/*
 * board contains two 2D arrays "field" and "graphics"
 * "field" is all about "checking if two object collide" like "did the snake run into an apple or a wall?"
 * so the invisible array "field" is used to compare object positions, to let the game logic decide what to do next.
 * "graphics" is "the board" the players will see from the game: an array of emptiness where at one place is an apple image
 * and at some other places are images that look - all together - like a snake... that's what "graphics" do right?
 * So both arrays contains information about the same objects in game at the same index.
 */

class Board {
    let pxSize : CGFloat            // this large is the whole board (in pixel)
    let pxFieldSize : CGFloat       // that's the size of every rectangled "field" within the board, containing graphics (in pixel)
    let fields : Int = global.boardSize // that's the size of the board in "rectangles" like "15x15"
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
            //if random positioning took too long (which occurs if snake is very large), find next empty field
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
    
    func clearMap () {
        for line in 0..<fields {
            for row in 0..<fields {
                if line == 0 || line == fields-1 {
                    field[line][row] = fieldCondition.wall
                }
                else if row == 0 || row == fields-1 {
                    field[line][row] = fieldCondition.wall
                }
                else {
                    field[line][row] = fieldCondition.empty
                }
                graphics[line][row]!.image = TEmpty.image
            }
        }
    }
    
    //every object which is drawn (i.e. snake or apple) knows it's position within the board
    //these "update" functions get the positions from the objects to put everything at the right place
    
    func updateAppleOnMap(_ apple : GameObject) {
        field[Int(apple.boardPos.y)][Int(apple.boardPos.x)] = fieldCondition.apple
    }
    
    func updatePlayerOnMap(_ player : SnakeHead) {
        for part in player.Parts {
            field[Int(part.boardPos.y)][Int(part.boardPos.x)] = fieldCondition.snake
        }
    }
    
    func updateMap(_ player : SnakeHead,_ apple : GameObject) {
        for line in 1..<fields-1 {
            for row in 1..<fields-1 {
                field[line][row] = fieldCondition.empty
            }
        }
        updateAppleOnMap(apple)
        updatePlayerOnMap(player)
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
