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

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreWindow: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    var highScoreLabels : [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showHighScores()
    }
    
    private func fetchData() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Highscores")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                for idx in 0..<10 {
                    globalHighScores[idx] = data.value(forKey: "score\(idx+1)") as! Int
                }
            }
        } catch {
            print("Fetching data Failed!")
        }
    }
    
    func saveData() {
        let entity = NSEntityDescription.entity(forEntityName: "Highscores", in: context)
        let actualHighScore = NSManagedObject(entity: entity!, insertInto: context)
        for idx in 0..<10 {
            actualHighScore.setValue(globalHighScores[idx], forKey: "score\(idx+1)")
        }
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing Data Failed")
        }
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
            let highScoreLabel = AppleCounterLabel(frame: CGRect(x: labelXPos-50, y: 3*labelYPos+idx*32, width: 100, height: 30), score: globalHighScores[idx])
            highScoreWindow.addSubview(highScoreLabel)
            highScoreLabels.append(highScoreLabel)
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
        
        let countString = NSMutableAttributedString(attributedString: stringLeftPart)
        countString.append(NSAttributedString.init(string: "\(labelScore)"))
        self.attributedText = countString
    }
    
    func countUp() {
        labelScore += 1
        let countString = NSMutableAttributedString(attributedString: stringLeftPart)
        countString.append(NSAttributedString.init(string: String(labelScore)))
        self.attributedText = countString
    }
}
