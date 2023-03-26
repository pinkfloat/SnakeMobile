/*
*   Copyright: (c) 2023 Sabrina Otto. All rights reserved.
*   This work is licensed under the terms of the MIT license.
*/

import UIKit

enum Direction: Int {
    case up, right, down, left
}

//in fact: only "apple" is an instance of "GameObject" and "SnakeHead" and "SnakePart" will inherit from it

class GameObject : Equatable {
    var boardPos : CGPoint
    var oldPos : CGPoint?
    var dir : Direction?        //apples don't need directions and old position info's, but the snake subclasses do ...
    var oldDir : Direction?     //and are sometimes handled in functions via "pointer to game objects" that both of them can be called
    var imageObj : imagePart    //can be found in "Image.swift"
    
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
