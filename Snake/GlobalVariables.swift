//
//  GlobalVariables.swift
//  Snake
//
//  Created by Echo on 18.01.21.
//

struct globalSettings {
    var boardSize : Int = 20
    var gameSpeed : Float = 0.5
    var sound = true
}

var global = globalSettings()
var globalHighScores : [Int] = Array (repeating: 0, count: 10)
var globalHighScoreNames : [String] = Array (repeating: "", count: 10)
