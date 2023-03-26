/*
*   Copyright: (c) 2023 Sabrina Otto. All rights reserved.
*   This work is licensed under the terms of the MIT license.
*/

import UIKit

//snake body parts and tail are instances of "SankePart"

class SnakePart : GameObject {
    var previous : GameObject

    init(boardPosition : CGPoint, direction : Direction, previousPart : GameObject, image : imagePart) {
        previous = previousPart
        super.init(boardPosition: boardPosition, image: image)
        dir = direction
        oldDir = direction
    }
    
    convenience init(boardPosition : CGPoint, direction : Direction, previousPart : GameObject) {
        self.init(boardPosition : boardPosition, direction : direction, previousPart : previousPart, image : TApple)
        getBodyImage()
    }
    
    static func ==(lPart: SnakePart, rPart: SnakePart) -> Bool {
        return lPart.boardPos == rPart.boardPos && lPart.dir == rPart.dir
    }
    
    func getBodyImage(){
        switch(dir!) {
            case Direction.up:
                switch(oldDir!) {
                    case Direction.up:      imageObj = TUpDown;     break;
                    case Direction.down:    imageObj = TUpDown;     break;
                    case Direction.right:   imageObj = TUpLeft;     break;
                    case Direction.left:    imageObj = TUpRight;    break;
                }
            break;
            case Direction.right:
                switch(oldDir!) {
                    case Direction.up:      imageObj = TDownRight;  break;
                    case Direction.right:   imageObj = TLeftRight;  break;
                    case Direction.left:    imageObj = TLeftRight;  break;
                    case Direction.down:    imageObj = TUpRight;    break;
                }
            break;
            case Direction.down:
                switch(oldDir!) {
                    case Direction.up:      imageObj = TUpDown;     break;
                    case Direction.down:    imageObj = TUpDown;     break;
                    case Direction.right:   imageObj = TLeftDown;   break;
                    case Direction.left:    imageObj = TDownRight;  break;
                }
            break;
            case Direction.left:
                switch(oldDir!) {
                    case Direction.up:      imageObj = TLeftDown;   break;
                    case Direction.right:   imageObj = TLeftRight;  break;
                    case Direction.left:    imageObj = TLeftRight;  break;
                    case Direction.down:    imageObj = TUpLeft;     break;
                }
            break;
        }
    }
    
    func getTailImage(){
        switch(dir!) {
            case Direction.up:       imageObj = TTailUp;            break;
            case Direction.right:    imageObj = TTailRight;         break;
            case Direction.down:     imageObj = TTailDown;          break;
            case Direction.left:     imageObj = TTailLeft;          break;
        }
    }
    
}
