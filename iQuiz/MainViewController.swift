//
//  ViewController.swift
//  iQuiz
//
//  Created by vinh on 5/10/24.
//

import UIKit

class QuizTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
}

struct Quiz : Codable {
    
    struct Question : Codable {
        let text : String
        let answer : String
        let answers : [String]
    }
    
    let title : String
    let desc : String
    let questions : [Question]
}

@MainActor
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    

    var quizURLString = UserDefaults.standard.string(forKey: "url") ?? "http://tednewardsandbox.site44.com/questions.json"

    @Published var quizzes : [Quiz] = []
    var quizIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(fetchQuiz), for: .valueChanged)
        tableView.refreshControl = refreshControl
        fetchQuiz()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySegue" {
            if let quizVC = segue.destination as? QuizViewController {
                quizVC.quiz = quizzes[quizIndex]
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.quizIndex = indexPath.row
        performSegue(withIdentifier: "displaySegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableCell", for: indexPath) as! QuizTableCell
        let quiz = quizzes[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.descLabel.text = quiz.desc
        return cell
    }
    
    @objc func fetchQuiz(){
        let quizURL = URL(string: quizURLString)
        let alert = UIAlertController(title: "Error", message: "There was an error with the networking when fetching quiz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        DispatchQueue.global().async {

            let task = URLSession.shared.dataTask(with: quizURL!) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.quizzes = try decoder.decode(Array<Quiz>.self, from: data!)
                } catch {
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            task.resume()
        }
        
    }

}

