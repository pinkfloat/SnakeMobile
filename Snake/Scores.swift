//
//  Scores.swift
//  Snake
//
//  Created by Echo on 06.01.21.
//

import UIKit
import CoreData

class HighScoreViewController: UIViewController {
    
    //stuff for saving data like new highscores and corresponding player name
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    //conatains the highscoretable, the "resetQuestionWindow" and the back- and reset-buttons
    @IBOutlet weak var highScoreWindow: UIView!
    var highScoreLabels : [AppleCounterLabel] = []  //contains the ten shown highscores
    
    //these things ask the user, if he is shure about resetting his highscores
    @IBOutlet weak var resetQuestionWindow: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetQuestionWindow.isHidden = true
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showHighScores()
    }
    
    private func showHighScores() {
        let labelXPos = Int(highScoreWindow.frame.size.width/2)
        let labelYPos = Int(highScoreWindow.frame.size.height/15)
        
        let titleLabel = UILabel(frame: CGRect(x: labelXPos-100, y: labelYPos, width: 200, height: 50))
        titleLabel.text = "Highscores"
        titleLabel.font = UIFont(name: "Arial", size: 35)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        highScoreWindow.addSubview(titleLabel)
        
        for idx in 0..<10 {
            let highScoreLabel = AppleCounterLabel(frame: CGRect(x: labelXPos-120, y: 3*labelYPos+idx*32, width: 200, height: 30), score: globalHighScores[idx])
            highScoreLabel.addName(name: globalHighScoreNames[idx])
            highScoreWindow.addSubview(highScoreLabel)
            highScoreLabels.append(highScoreLabel)
        }
    }
    
//___FUNCTIONS_FOR_DELETING_HIGHSCORES___
    
    @IBAction func askForHighscoreReset(_ sender: UIButton) {
        resetQuestionWindow.isHidden = false
        highScoreWindow.bringSubviewToFront(resetQuestionWindow)
        highScoreWindow.bringSubviewToFront(infoLabel)
        highScoreWindow.bringSubviewToFront(yesButton)
        highScoreWindow.bringSubviewToFront(noButton)
    }

    @IBAction func resetHighscores(_ sender: UIButton) {
        for idx in 0..<10 {
            globalHighScores[idx] = 0
            globalHighScoreNames[idx] = ""
            saveHighscoreData(self.context)
        }
        for label in highScoreLabels {
            label.reset()
        }
        resetQuestionWindow.isHidden = true
    }
    
    @IBAction func breakUpReset(_ sender: UIButton) {
        resetQuestionWindow.isHidden = true
    }
}

/*
 * This kind of label got an apple-symbol in the left part of it's string
 * it's used to count the apples in the snake game (in the upper right corner)
 * and it's used ten times in the highscore table (to show the highscores)
*/

class AppleCounterLabel : UILabel {
    
    var labelScore : Int
    let stringLeftPart = NSMutableAttributedString()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, score: Int) {
        labelScore = score
        super.init(frame: frame)
        self.textColor = .white
        let attach = NSTextAttachment()
        attach.image = TApple.image
        attach.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        stringLeftPart.append(NSAttributedString(attachment: attach))
        stringLeftPart.append(NSAttributedString(string: "  "))
        
        setShownScoreTo("\(labelScore)")
    }
    
    private func setShownScoreTo(_ shownScore : String) {
        let countString = NSMutableAttributedString(attributedString: stringLeftPart)
        countString.append(NSAttributedString.init(string: shownScore))
        self.attributedText = countString
    }
    
    func reset() {
        labelScore = 0
        setShownScoreTo("0")
    }
    
    func countUp() {
        labelScore += 1
        setShownScoreTo("\(labelScore)")
    }
    
    func addName(name: String) {
        let newLabel = NSMutableAttributedString(attributedString: self.attributedText!)
        newLabel.append(NSAttributedString(string: "  "))
        newLabel.append(NSAttributedString.init(string: name))
        self.attributedText = newLabel
    }
}
