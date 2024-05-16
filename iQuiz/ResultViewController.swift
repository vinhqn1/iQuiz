//
//  ResultViewController.swift
//  iQuiz
//
//  Created by vinh on 5/15/24.
//

import UIKit

class ResultViewController : UIViewController {
    var score : Int?
    var total : Int?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Total Score: \(score!)/\(total!)"
        let ratio : Double = Double(score!) / Double(total!)
        switch ratio {
        case 0:
            descLabel.text = "Terrible..."
        case 0..<0.5:
            descLabel.text = "Good try"
        case 0.5..<0.9:
            descLabel.text = "Good job"
        case 0.9..<1:
            descLabel.text = "Almost"
        case 1:
            descLabel.text = "Perfect!"
        default:
            descLabel.text = "Good job"
        }
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    
    @IBAction func exitQuiz(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
