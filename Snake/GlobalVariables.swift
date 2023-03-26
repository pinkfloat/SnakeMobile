/*
*   Copyright: (c) 2023 Sabrina Otto. All rights reserved.
*   This work is licensed under the terms of the MIT license.
*/

struct globalSettings {
    var boardSize : Int = 20
    var gameSpeed : Float = 0.5
    var sound = true
}

var global = globalSettings()
var globalHighScores : [Int] = Array (repeating: 0, count: 10)
var globalHighScoreNames : [String] = Array (repeating: "", count: 10)
