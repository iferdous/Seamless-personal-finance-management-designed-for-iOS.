//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI
import Foundation

// MARK: - Expense Model
struct Expense: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var remark: String
    var amount: Double
    var date: Date
    var type: ExpenseType
    var color: String
    var category: ExpenseCategory
    
    init(remark: String, amount: Double, date: Date, type: ExpenseType, color: String, category: ExpenseCategory = .other) {
        self.remark = remark
        self.amount = amount
        self.date = date
        self.type = type
        self.color = color
        self.category = category
    }
}

// MARK: - Expense Type
enum ExpenseType: String, CaseIterable, Codable {
    case income = "Income"
    case expense = "Expense"
    case all = "All"
}

// MARK: - Expense Categories
enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transportation = "Transportation"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case bills = "Bills"
    case healthcare = "Healthcare"
    case education = "Education"
    case travel = "Travel"
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transportation: return "car.fill"
        case .shopping: return "bag.fill"
        case .entertainment: return "tv.fill"
        case .bills: return "doc.text.fill"
        case .healthcare: return "heart.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .salary: return "dollarsign.circle.fill"
        case .freelance: return "briefcase.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .transportation: return .blue
        case .shopping: return .pink
        case .entertainment: return .purple
        case .bills: return .red
        case .healthcare: return .green
        case .education: return .indigo
        case .travel: return .cyan
        case .salary: return .mint
        case .freelance: return .yellow
        case .investment: return .teal
        case .other: return .gray
        }
    }
}

// MARK: - Sample Data
var sample_expenses: [Expense] = [
    Expense(remark: "Magic Keyboard", amount: 99, date: Date(timeIntervalSince1970: 1652987245), type: .expense, color: "Yellow", category: .shopping),
    Expense(remark: "Lunch", amount: 19, date: Date(timeIntervalSince1970: 1652814445), type: .expense, color: "Red", category: .food),
    Expense(remark: "Magic Trackpad", amount: 99, date: Date(timeIntervalSince1970: 1652382445), type: .expense, color: "Purple", category: .shopping),
    Expense(remark: "Uber Ride", amount: 20, date: Date(timeIntervalSince1970: 1652296045), type: .expense, color: "Green", category: .transportation),
    Expense(remark: "Amazon Purchase", amount: 299, date: Date(timeIntervalSince1970: 1652209645), type: .expense, color: "Blue", category: .shopping),
    Expense(remark: "Salary", amount: 3000, date: Date(timeIntervalSince1970: 1652036845), type: .income, color: "Mint", category: .salary),
    Expense(remark: "Netflix", amount: 15.99, date: Date(timeIntervalSince1970: 1651864045), type: .expense, color: "Red", category: .entertainment),
    Expense(remark: "Movie Ticket", amount: 12, date: Date(timeIntervalSince1970: 1651691245), type: .expense, color: "Pink", category: .entertainment),
    Expense(remark: "Freelance Work", amount: 500, date: Date(timeIntervalSince1970: 1651518445), type: .income, color: "Teal", category: .freelance),
    Expense(remark: "Groceries", amount: 85, date: Date(timeIntervalSince1970: 1651432045), type: .expense, color: "Orange", category: .food),
]

// MARK: - Color Helper Extension
extension Color {
    static func fromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "red": return .red
        case "pink": return .pink
        case "purple": return .purple
        case "indigo": return .indigo
        case "blue": return .blue
        case "cyan": return .cyan
        case "teal": return .teal
        case "mint": return .mint
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "brown": return .brown
        case "gray": return .gray
        case "black": return .black
        default: return .blue
        }
    }
}
