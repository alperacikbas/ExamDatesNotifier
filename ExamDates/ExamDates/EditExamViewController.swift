//
//  EditExamViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 3.05.2025.
//

import Foundation
import UIKit
import UserNotifications

class EditExamViewController: UIViewController {
    
    
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var examDatePicker: UIDatePicker!
    @IBOutlet weak var hoursBeforeStepper: UIStepper!
    @IBOutlet weak var hoursLabel: UILabel!
    
    var exam: Exam!
    var examIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        examNameTextField.text = exam.name
        examDatePicker.date = exam.date
        hoursBeforeStepper.value = Double(exam.notificationBeforeHours)
        hoursLabel.text = "\(Int(exam.notificationBeforeHours)) saat"
    }
    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        hoursLabel.text = "\(Int(sender.value)) saat"
    }
    
    
    @IBAction func saveChanges(_ sender: UIButton) {
        var exams = loadExams()
        var examToUpdate = exams[examIndex]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [examToUpdate.id])
        
        examToUpdate.name = examNameTextField.text ?? "Sınav"
        examToUpdate.date = examDatePicker.date
        examToUpdate.notificationBeforeHours = Double(hoursBeforeStepper.value)
        
        exams[examIndex] = examToUpdate
        
        if let data = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(data, forKey: "exams")
        }
        
        scheduleNotification(for: examToUpdate)
        
        let alert = UIAlertController(title: "Başarılı", message: "Sınav bilgileri güncellendi!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam.", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func deleteExam(_ sender: UIButton) {
        var exams = loadExams()
        
        let examToDelete = exams[examIndex]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [examToDelete.id])
        
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
        
        let alert = UIAlertController(title: "Silindi", message: "Sınav başarıyla silindi!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam.", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadExams() -> [Exam] {
        if let data = UserDefaults.standard.data(forKey: "exams"),
           let exams = try? JSONDecoder().decode([Exam].self, from: data) {
            return exams
        }
        return []
    }
}
