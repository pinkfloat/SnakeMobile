//
//  AppleCount.swift
//  Snake
//
//  Created by Echo on 01.01.21.
//

import UIKit

class AppleCounterLabel : UILabel {
    
    var count = 0
    let stringLeftPart = NSMutableAttributedString()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = .white
        let attach = NSTextAttachment()
        attach.image = TApple.image
        attach.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        stringLeftPart.append(NSAttributedString(attachment: attach))
        stringLeftPart.append(NSAttributedString(string: "  "))
        
        let countString = NSMutableAttributedString(attributedString: stringLeftPart)
        countString.append(NSAttributedString.init(string: "0"))
        self.attributedText = countString
    }
    
    func countUp () {
        count += 1
        let countString = NSMutableAttributedString(attributedString: stringLeftPart)
        countString.append(NSAttributedString.init(string: String(count)))
        self.attributedText = countString
    }
}
