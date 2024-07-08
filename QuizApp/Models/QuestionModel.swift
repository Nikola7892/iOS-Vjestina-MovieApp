import Foundation
import UIKit

struct Quiz {
    var currentQuestionId: Int
    var questionModel: QuestionModel
    var quizCompleted: Bool
    var quizWinningStatus: Bool = false
}

struct QuestionModel{
    var question: String
    var correctAnswer: String
    var allAnswers: [QuestionOption]
}

struct QuestionOption: Identifiable {
    var id: Int
    var option: String
    var isSelected: Bool = false
    var isCorrect: Bool = false
}
