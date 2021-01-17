//
//  Game.swift
//  Snake
//
//  Created by Echo on 27.12.20.
//

import UIKit
import AVFoundation

class Game {
    var isRunning = true
    var board : Board
    var player : SnakeHead
    var apple : GameObject
    var appleCounterLabel : AppleCounterLabel
    var alert : UIAlertController?
    var notificationSounds = [String: SystemSoundID]()
    var audio: AVAudioPlayer?
    
    init(_ gameWindow : UIView){
        player = SnakeHead(boardPosition: CGPoint.init(x: 5, y: 10), direction: Direction.right)
        let part1 = SnakePart(boardPosition: CGPoint.init(x: 4, y: 10), direction: Direction.right, previousPart : player)
        let part2 = SnakePart(boardPosition: CGPoint.init(x: 3, y: 10), direction: Direction.right, previousPart : part1, image: TTailRight)
        player.Parts.append(part1)
        player.Parts.append(part2)
        
        apple = GameObject(boardPosition: CGPoint.init(x: 13, y: 13))
        board = Board(gameWindow)
        self.board.replaceApple(apple)
        
        appleCounterLabel = AppleCounterLabel(frame: CGRect(x: board.pxSize-70, y: 0, width: 70, height: 30), score: 0)
        gameWindow.addSubview(appleCounterLabel)
    }
    
    private func setAlert(lose: Bool, message: String){
        if lose {
            alert = UIAlertController(title: "Game over", message: message, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: "You win", message: message, preferredStyle: .alert)
        }
    }
    
    func playSound(soundName: String, format: String) { // source: https://stackoverflow.com/questions/32036146/how-to-play-a-sound-using-swift
        if global.sound {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: format) else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                audio = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                 audio = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let audio = audio else { return }

                audio.play()

            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkCollision() -> Bool {
        if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.empty {
            return true
        }
        else if player.Parts.count == board.fields*board.fields-1 {
            setAlert(lose: false, message: "Player won, but no one will ever notice...")
            playSound(soundName: "win", format: "wav")
            return false
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.apple {
            appleCounterLabel.countUp()
            playSound(soundName: "gotApple", format: "wav")
            
            //resize snake
            let newPart = SnakePart(boardPosition: player.boardPos, direction: player.dir!, previousPart: player.Parts.last!)
            player.addSnakePart(newPart)
            
            board.replaceApple(apple)
            return true
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.wall {
            setAlert(lose: true, message:"Player crashes through wall!")
            playSound(soundName: "lose", format: "wav")
            return false
        }
        else if board.field[Int(player.boardPos.y)][Int(player.boardPos.x)] == fieldCondition.snake {
            setAlert(lose: true, message:"Player ate himself!")
            playSound(soundName: "lose", format: "wav")
            return false
        }
        else {
            setAlert(lose: true, message:"Player managed to came to an uninitialized field aka wormhole!")
            playSound(soundName: "lose", format: "wav")
            return false
        }
    }
    
    func checkIfHighScore(_ playerName : String) -> Int?{
        var newHighscorePosition : Int? = nil
        for idx in 0..<10{
            //if the score is higher than a highscore in list
            if appleCounterLabel.labelScore > globalHighScores[idx] {
                //set lower highscores to the next line
                var idy = 8
                while idy >= idx {
                    globalHighScores[idy+1] = globalHighScores[idy]
                    globalHighScoreNames[idy+1] = globalHighScoreNames[idy]
                    idy -= 1
                }
                
                //add ne highscore in list
                newHighscorePosition = idx
                globalHighScores[idx] = appleCounterLabel.labelScore
                globalHighScoreNames[idx] = playerName
                break
            }
        }
        return newHighscorePosition
    }
    
    func reset() {
        self.player.boardPos = CGPoint(x: 5, y: 10)
        self.player.oldPos = CGPoint(x: 5, y: 10)
        self.player.dir = Direction.right
        self.player.oldDir = Direction.right
        self.player.imageObj = THeadRight
        for part in self.player.Parts.reversed() {
            if part == self.player.Parts.first {
                part.boardPos = CGPoint(x: 4, y: 10)
                part.oldPos = CGPoint(x: 4, y: 10)
                part.dir = Direction.right
                part.oldDir = Direction.right
                part.imageObj = TLeftRight
            }
            else if part.previous == self.player.Parts.first {
                part.boardPos = CGPoint(x: 3, y: 10)
                part.oldPos = CGPoint(x: 3, y: 10)
                part.dir = Direction.right
                part.oldDir = Direction.right
                part.imageObj = TTailRight
            }
            else {
                self.player.Parts.removeLast(1)
            }
        }
        self.board.clearMap()
        self.board.updatePlayerOnMap(self.player)
        self.board.replaceApple(apple)
        self.board.updateAppleOnMap(self.apple)
        self.board.updateGraphics(self.player, self.apple)
        self.appleCounterLabel.reset()
        isRunning = true
    }
    
    func update() {
        self.player.moveForward()
        self.board.updateMap(self.player, self.apple)
        self.board.updateGraphics(self.player, self.apple)
        isRunning = checkCollision()
    }
}
