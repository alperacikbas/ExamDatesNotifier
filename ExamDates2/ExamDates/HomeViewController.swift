//
//  HomeViewController.swift
//  ExamDates
//
//  Created by Trakya9 on 2.05.2025.
//

import Foundation
import UIKit


class HomeViewController: UIViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func createExamTapped(_ sender: UIButton){
        performSegue(withIdentifier: "toCreateExam", sender: self)
    }
    
    @IBAction func viewSavedExamsTapped(_ sender: UIButton){
        performSegue(withIdentifier: "toSavedExams", sender: self)
    }
    
}
