/*
*   Copyright: (c) 2023 Sabrina Otto. All rights reserved.
*   This work is licensed under the terms of the MIT license.
*/

import UIKit

// the snake image is one bmp where 64x64 px rectangles are cut out

class imagePart{
    
    var image : UIImage!
    
    init(_ imagePosition : CGRect) {
        let source : UIImage! = UIImage(named: "snake-graphics.bmp")
        let cgImage : CGImage! = source.cgImage
        let croppedCGImage : CGImage! = cgImage.cropping(to: imagePosition)
        image = UIImage(cgImage: croppedCGImage)
    }
}

let THeadUp = imagePart(CGRect(x: 192, y: 0, width: 64, height: 64))
let THeadRight = imagePart(CGRect(x: 256, y: 0, width: 64, height: 64))
let THeadLeft = imagePart(CGRect(x: 192, y: 64, width: 64, height: 64))
let THeadDown = imagePart(CGRect(x: 256, y: 64, width: 64, height: 64))

let TDownRight = imagePart(CGRect(x: 0, y: 0, width: 64, height: 64))
let TLeftRight = imagePart(CGRect(x: 64, y: 0, width: 64, height: 64))
let TLeftDown = imagePart(CGRect(x: 128, y: 0, width: 64, height: 64))
let TUpRight = imagePart(CGRect(x: 0, y: 64, width: 64, height: 64))
let TUpDown = imagePart(CGRect(x: 128, y: 64, width: 64, height: 64))
let TUpLeft = imagePart(CGRect(x: 128, y: 128, width: 64, height: 64))

let TTailUp = imagePart(CGRect(x: 192, y: 128, width: 64, height: 64))
let TTailRight = imagePart(CGRect(x: 256, y: 128, width: 64, height: 64))
let TTailLeft = imagePart(CGRect(x: 192, y: 192, width: 64, height: 64))
let TTailDown = imagePart(CGRect(x: 256, y: 192, width: 64, height: 64))

let TApple = imagePart(CGRect(x: 0, y: 192, width: 64, height: 64))
let TEmpty = imagePart(CGRect(x: 64, y: 192, width: 64, height: 64))
