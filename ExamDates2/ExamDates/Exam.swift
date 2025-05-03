//
//  Exam.swift
//  ExamDates
//
//  Created by Trakya9 on 2.05.2025.
//

import Foundation
import UIKit

struct Exam: Codable {
    var name: String
    var date: Date
    var notificationBeforeHours: Double
}
