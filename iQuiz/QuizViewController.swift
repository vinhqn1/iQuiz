//
//  QuizViewController.swift
//  iQuiz
//
//  Created by vinh on 5/13/24.
//

import UIKit

class QuizViewController : UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var button1: UILabel!
    @IBOutlet weak var button2: UILabel!
    @IBOutlet weak var button3: UILabel!
    @IBOutlet weak var button4: UILabel!
    
    var selectedButton : UILabel?
    
    var quiz : Quiz?
    var currentQuestion : Int = 0
    var correctAnswers : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(submitAnswer))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadQuestion()
    }
    
    func loadQuestion() {
        if currentQuestion < ((quiz?.questions.count)!) {
            let question = quiz?.questions[currentQuestion]
            button1.text = question?.answers[0]
            button2.text = question?.answers[1]
            button3.text = question?.answers[2]
            button4.text = question?.answers[3]
            questionLabel.text = question?.text
        } else {
            performSegue(withIdentifier: "resultsSegue", sender: self)
        }
    }
    
    
    @IBAction func answerSelect(_ sender: UITapGestureRecognizer) {
        if selectedButton != nil {
            selectedButton?.backgroundColor = .systemGray
        }
        
        if let label = sender.view as? UILabel {
            selectedButton = label
            label.backgroundColor = .systemGreen
        }
    }

    
    @IBAction func submitAnswer(_ sender: Any) {
        if selectedButton != nil {
            performSegue(withIdentifier: "answerSegue", sender: self)
        }
    }
    

    @IBAction func exitQuiz(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerSegue" {
            if let answerVC = segue.destination as? AnswerViewController {
                let answerString : String? = quiz?.questions[currentQuestion].answer
                let answerIndex : Int = Int(answerString!)! - 1
                
                answerVC.answer = selectedButton?.text
                if selectedButton?.text == quiz?.questions[currentQuestion].answers[answerIndex] {
                    answerVC.result = true
                    correctAnswers += 1
                } else {
                    answerVC.result = false
                }
                
                currentQuestion += 1
                
                selectedButton?.backgroundColor = .systemGray
                selectedButton = nil
            }
            
        } else if segue.identifier == "resultsSegue" {
            if let resultsVC = segue.destination as? ResultViewController {
                resultsVC.score = correctAnswers
                resultsVC.total = currentQuestion
            }
        }
    }
    
}
