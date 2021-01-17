//
//  Scores.swift
//  Snake
//
//  Created by Echo on 06.01.21.
//
//  used source for storing and fetching data:
//  https://stackoverflow.com/questions/25586593/coredata-swift-how-to-save-and-load-data

import UIKit
import CoreData

var globalHighScores : [Int] = Array (repeating: 0, count: 10)
var globalHighScoreNames : [String] = Array (repeating: "", count: 10)

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreWindow: UIView!
    @IBOutlet weak var resetQuestionWindow: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var highScoreLabels : [AppleCounterLabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetQuestionWindow.isHidden = true
        context = appDelegate.persistentContainer.viewContext
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showHighScores()
    }
    
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
            saveData()
        }
        for label in highScoreLabels {
            label.reset()
        }
        resetQuestionWindow.isHidden = true
    }
    
    @IBAction func breakUpReset(_ sender: UIButton) {
        resetQuestionWindow.isHidden = true
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
    
    private func saveData() {
        print("Storing Data..")
        var entity = NSEntityDescription.entity(forEntityName: "Highscores", in: context)
        let actualHighScore = NSManagedObject(entity: entity!, insertInto: context)
        for idx in 0..<10 {
            actualHighScore.setValue(globalHighScores[idx], forKey: "score\(idx+1)")
        }
        do {
            try context.save()
        } catch {
            print("Storing Highscore Data Failed")
        }
        
        entity = NSEntityDescription.entity(forEntityName: "HighscoreUsers", in: context)
        let actualName = NSManagedObject(entity: entity!, insertInto: context)
        for idx in 0..<10 {
            actualName.setValue(globalHighScoreNames[idx], forKey: "name\(idx+1)")
        }
        do {
            try context.save()
        } catch {
            print("Storing User Names Failed")
        }
        
    }
    
    private func fetchData() {
        print("Fetching Data..")
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Highscores")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                for idx in 0..<10 {
                    globalHighScores[idx] = data.value(forKey: "score\(idx+1)") as! Int
                }
            }
        } catch {
            print("Fetching Highscore Data Failed!")
        }
        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighscoreUsers")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                for idx in 0..<10 {
                    globalHighScoreNames[idx] = data.value(forKey: "name\(idx+1)") as! String
                }
            }
        } catch {
            print("Fetching User Names Failed!")
        }
    }
}

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
