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
                graphics[line][row]!.image = TEmpty.image
                gameWindow.addSubview(graphics[line][row]!)
            }
        }
    }
}
