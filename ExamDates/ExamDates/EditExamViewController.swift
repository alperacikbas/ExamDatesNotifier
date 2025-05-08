//
//  EditExamViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 3.05.2025.
//

import Foundation
import UIKit

class EditExamViewController: UIViewController {
    
    
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var examDatePicker: UIDatePicker!
    @IBOutlet weak var hoursBeforeStepper: UIStepper!
    @IBOutlet weak var hoursLabel: UILabel!
    
    var exam: Exam!
    var examIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("examNameField is nil? \(examNameTextField == nil)")
        examNameTextField.text = exam.name
        examDatePicker.date = exam.date
        hoursBeforeStepper.value = Double(exam.notificationBeforeHours)
        hoursLabel.text = "\(exam.notificationBeforeHours) saat"
    }
    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        hoursLabel.text = "\(Int(sender.value)) saat"
    }
    
    
    @IBAction func saveChanges(_ sender: UIButton) {
        var exams = loadExams()
        exams[examIndex].name = examNameTextField.text ?? "Sınav"
        exams[examIndex].date = examDatePicker.date
        exams[examIndex].notificationBeforeHours = Double(hoursBeforeStepper.value)
        
        if let data = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(data, forKey: "exams")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteExam(_ sender: UIButton) {
        var exams = loadExams()
        
        print("silme işlemi için examIndex: \(examIndex!)")
        print("Exams dizisinin boyutu: \(exams.count)")
        
        if examIndex < exams.count {
            exams.remove(at: examIndex)
        } else {
            print("Hata: index sınır dışı")
            return
        }
        
        if let data = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(data, forKey: "exams")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadExams() -> [Exam] {
        if let data = UserDefaults.standard.data(forKey: "exams"),
           let exams = try? JSONDecoder().decode([Exam].self, from: data) {
            return exams
        }
        return []
    }
}
