//
//  ExamListViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 3.05.2025.
//

//
//  ExamListViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 2.05.2025.
//

import Foundation
import UIKit

class ExamListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var exams: [Exam] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        exams = loadExams()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exams = loadExams()
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as? ExamCell else {
            return UITableViewCell()
        }
        
        let exam = exams[indexPath.row]
        cell.examLabel.text = "\(exam.name) - \(formattedDate(exam.date)) - \(exam.notificationBeforeHours) saat önce"
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditExam",
           let editVC = segue.destination as? EditExamViewController,
           let button = sender as? UIButton {
            
            let selectedExam = exams[button.tag]
            editVC.exam = selectedExam
            editVC.examIndex = button.tag
        }
    }
    
    
    @objc func editButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toEditExam", sender: sender)
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
    func loadExams() -> [Exam] {
        if let data = UserDefaults.standard.data(forKey: "exams"),
           let exams = try? JSONDecoder().decode([Exam].self, from: data) {
            return exams
        }
        return []
    }
}
