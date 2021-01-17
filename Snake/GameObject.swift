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

class GameObject : Equatable {
    var boardPos : CGPoint
    var oldPos : CGPoint?
    var dir : Direction?
    var oldDir : Direction?
    var imageObj : imagePart
    
    init(boardPosition : CGPoint, image : imagePart) {
        boardPos = boardPosition
        oldPos = boardPosition
        imageObj = image
    }
    
    convenience init(boardPosition : CGPoint) {
        self.init(boardPosition : boardPosition, image : TApple)
    }
    
    static func ==(lObj: GameObject, rObj: GameObject) -> Bool {
        return lObj.boardPos == rObj.boardPos && lObj.imageObj.image == rObj.imageObj.image
    }
}
