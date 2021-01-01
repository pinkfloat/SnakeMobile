//
//  SnakeHead.swift
//  Snake
//
//  Created by Echo on 27.12.20.
//

import UIKit

class SnakeHead : GameObject {
    var Parts : [SnakePart] = []
    
    init(boardPosition : CGPoint, direction : Direction, image : imagePart) {
        super.init(boardPosition: boardPosition, image: image)
        dir = direction
        oldDir = direction
    }
    
    convenience init(boardPosition : CGPoint, direction : Direction) {
        let image : imagePart
        switch (direction) {
            case Direction.up:      image = THeadUp; break;
            case Direction.right:   image = THeadRight; break;
            case Direction.down:    image = THeadDown; break;
            case Direction.left:    image = THeadLeft; break;
        }
        self.init(boardPosition : boardPosition, direction : direction, image : image)
    }
    
    func changeDirUp() {
        if dir != Direction.down {
            dir = Direction.up
            imageObj = THeadUp
        }
    }
    
    func changeDirLeft() {
        if dir != Direction.right {
            dir = Direction.left
            imageObj = THeadLeft
        }
    }
    
    func changeDirDown() {
        if dir != Direction.up {
            dir = Direction.down
            imageObj = THeadDown
        }
    }
    
    func changeDirRight() {
        if dir != Direction.left {
            dir = Direction.right
            imageObj = THeadRight
        }
    }
    
    func addSnakePart(_ newPart : SnakePart) {
        Parts.append(newPart)
    }
    
    func moveForward() {
        oldPos = boardPos
        oldDir = dir!
        switch(dir!) {
            case Direction.up:      boardPos.y -= 1; break;
            case Direction.right:   boardPos.x += 1; break;
            case Direction.down:    boardPos.y += 1; break;
            case Direction.left:    boardPos.x -= 1; break;
        }
        
        for part in Parts.reversed() {
            //follow the previous snakepart
            if part != Parts.first {
                part.boardPos = part.previous.boardPos
                part.oldDir = part.dir!
                part.dir! = part.previous.dir!
                    
                //if tail
                if part == Parts.last {
                    part.getTailImage()
                }
                else {
                    part.getBodyImage()
                }
            }
            //follow head
            else {
                part.boardPos = part.previous.oldPos!
                part.oldDir = part.dir
                part.dir = part.previous.oldDir!
                part.getBodyImage()
            }
        }
    }
}
