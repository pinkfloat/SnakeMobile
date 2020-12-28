//
//  SnakeHead.swift
//  Snake
//
//  Created by Echo on 27.12.20.
//

import UIKit

class SnakeHead : GameObject {
    var Parts : [SnakePart] = []
    var oldPos : CGPoint
    var dir : Direction
    var oldDir : Direction
    
    init(boardPosition : CGPoint, direction : Direction, image : imagePart) {
        oldPos = boardPosition
        dir = direction
        oldDir = direction
        super.init(boardPosition: boardPosition, image: image)
    }
    
    convenience init(boardPosition : CGPoint, direction : Direction) {
        self.init(boardPosition : boardPosition, direction : direction, image : TApple)
        getHeadImage()
    }
    
    private func getHeadImage() {
        switch (dir) {
            case Direction.up: imageObj = THeadUp; break;
            case Direction.right: imageObj = THeadRight; break;
            case Direction.down: imageObj = THeadDown; break;
            case Direction.left: imageObj = THeadLeft; break;
        }
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
    func moveForward() {
        oldPos = boardPos
        oldDir = dir
        switch(dir) {
            case Direction.up: boardPos.y -= 1; break;
            case Direction.right: boardPos.x += 1; break;
            case Direction.down: boardPos.y += 1; break;
            case Direction.left: boardPos.x -= 1; break;
        }
    }
}
