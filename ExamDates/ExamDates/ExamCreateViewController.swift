//
//  ExamCreateViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 3.05.2025.
//

//
//  ExamCreateViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 2.05.2025.
//

import Foundation
import UIKit
import UserNotifications

class ExamCreateViewController: UIViewController {
    
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationBeforeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton){
        guard let examName = examNameTextField.text, !examName.isEmpty,
              let hoursText = notificationBeforeTextField.text,
              let hoursBefore = Double(hoursText) else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doğru doldurun.")
            return
        }
        
        let examDate = datePicker.date
        let exam = Exam(name: examName, date: examDate, notificationBeforeHours: hoursBefore)
        
        saveExam(exam)
        scheduleNotification(for: exam)
        
        let alert = UIAlertController(title: "Başarılı", message: "Sınav zamanlayıcısı oluşturuldu!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


func saveExam(_ exam: Exam){
    var exams = loadExams()
    exams.append(exam)
    if let data = try? JSONEncoder().encode(exams) {
        UserDefaults.standard.set(data, forKey: "exams")
    }
}


func loadExams() -> [Exam] {
    if let data = UserDefaults.standard.data(forKey: "exams"),
       let exams = try? JSONDecoder().decode([Exam].self, from: data) {
        return exams
    }
    return[]
}


func scheduleNotification(for exam: Exam) {
    let notificationCenter = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "Sınav Yaklaşıyor"
    content.body = "\(exam.name) sınavına az kaldı!"
    content.sound = UNNotificationSound.default
    
    let notificationDate = exam.date.addingTimeInterval(-exam.notificationBeforeHours * 3600)
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    notificationCenter.add(request) { error in
        if let error = error {
            print("Bildirim hatası: \(error.localizedDescription)")
        }
    }
}





