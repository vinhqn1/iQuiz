//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by vinh on 5/15/24.
//

import UIKit

class AnswerViewController : UIViewController {
    
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var answer : String?
    var result : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextQuestion))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if answer != nil {
            answerLabel.text = answer
        }
        if result != nil && result! {
            resultLabel.text = "Correct"
            answerLabel.backgroundColor = .systemGreen
        } else if result != nil && !result! {
            resultLabel.text = "Wrong"
            answerLabel.backgroundColor = .systemRed
        }
    }
    
    @IBAction func exitQuiz(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func nextQuestion(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
