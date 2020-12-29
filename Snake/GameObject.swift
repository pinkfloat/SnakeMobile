//
//  GameObject.swift
//  Snake
//
//  Created by Echo on 26.12.20.
//

import UIKit

enum Direction: Int {
    case up, right, down, left
}

class GameObject {
    var boardPos : CGPoint
    var oldPos : CGPoint?
    var dir : Direction?
    var oldDir : Direction?
    var imageObj : imagePart
    
    init(boardPosition : CGPoint, image : imagePart) {
        boardPos = boardPosition
        imageObj = image
    }
    
    convenience init(boardPosition : CGPoint) {
        self.init(boardPosition : boardPosition, image : TApple)
    }
}
