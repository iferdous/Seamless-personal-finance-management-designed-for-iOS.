//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    // Sample data of expenses
    @Published var expenses: [Expense] = sample_expenses
    
    // Filter properties
    @Published var selectedType: ExpenseType = .all
    @Published var selectedCategory: ExpenseCategory = .other
    @Published var showFilterSheet = false
    
    // Add expense properties
    @Published var showAddExpenseSheet = false
    
    // Budget settings properties
    @Published var showBudgetSettings = false
    
    // Budget properties
    @Published var monthlyBudget: Double = 2000.0
    @Published var budgets: [ExpenseCategory: Double] = [:]
    
    // User settings
    @AppStorage("monthlyBudget") private var storedMonthlyBudget: Double = 2000.0
    @AppStorage("categoryBudgets") private var storedCategoryBudgets: Data = Data()
    
    init() {
        // Fetching current month starting date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        startDate = calendar.date(from: components) ?? Date()
        currentMonthStartDate = calendar.date(from: components) ?? Date()
        
        // Load saved budgets
        loadSavedBudgets()
        
        // Initialize default budgets if none exist
        if budgets.isEmpty {
            setupDefaultBudgets()
        }
    }
    
    // MARK: - Budget Functions
    func loadSavedBudgets() {
        // Load monthly budget
        monthlyBudget = storedMonthlyBudget
        
        // Load category budgets
        if let decodedBudgets = try? JSONDecoder().decode([ExpenseCategory: Double].self, from: storedCategoryBudgets) {
            budgets = decodedBudgets
        }
    }
    
    func saveBudgets() {
        // Save monthly budget
        storedMonthlyBudget = monthlyBudget
        
        // Save category budgets
        if let encodedBudgets = try? JSONEncoder().encode(budgets) {
            storedCategoryBudgets = encodedBudgets
        }
    }
    
    func setupDefaultBudgets() {
        budgets = [
            .food: 400,
            .transportation: 200,
            .shopping: 300,
            .entertainment: 150,
            .bills: 500,
            .healthcare: 200,
            .education: 100,
            .travel: 300,
            .other: 150
        ]
        saveBudgets() // Save the default budgets
    }
    
    func getBudgetForCategory(_ category: ExpenseCategory) -> Double {
        return budgets[category] ?? 0
    }
    
    func getSpentForCategory(_ category: ExpenseCategory) -> Double {
        let currentMonthExpenses = getCurrentMonthExpenses()
        return currentMonthExpenses
            .filter { $0.category == category && $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getBudgetProgress(_ category: ExpenseCategory) -> Double {
        let budget = getBudgetForCategory(category)
        let spent = getSpentForCategory(category)
        return budget > 0 ? min(spent / budget, 1.0) : 0
    }
    
    // MARK: - Expense Functions
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveBudgets() // Save budgets when expenses change
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }
    
    func getCurrentMonthExpenses() -> [Expense] {
        let calendar = Calendar.current
        return expenses.filter { expense in
            calendar.isDate(expense.date, equalTo: currentMonthStartDate, toGranularity: .month)
        }
    }
    
    func getFilteredExpenses() -> [Expense] {
        let currentMonthExpenses = getCurrentMonthExpenses()
        
        var filtered = currentMonthExpenses
        
        // Filter by type
        if selectedType != .all {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    // MARK: - Date Functions
    func currentMonthDateString() -> String {
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " +
               Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: - Currency Functions
    func convertExpensesToCurrency(expenses: [Expense], type: ExpenseType = .all) -> String {
        let totalValue = expenses.reduce(0) { partialResult, expense in
            switch type {
            case .income:
                return partialResult + (expense.type == .income ? expense.amount : 0)
            case .expense:
                return partialResult + (expense.type == .expense ? expense.amount : 0)
            case .all:
                return partialResult + (expense.type == .income ? expense.amount : -expense.amount)
            }
        }
        
        return convertNumberToPrice(value: totalValue)
    }
    
    func convertNumberToPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    // MARK: - Statistics Functions
    func getTotalIncome() -> Double {
        return getCurrentMonthExpenses()
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getTotalExpenses() -> Double {
        return getCurrentMonthExpenses()
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getRemainingBudget() -> Double {
        return monthlyBudget - getTotalExpenses()
    }
    
    func getBudgetProgress() -> Double {
        let totalExpenses = getTotalExpenses()
        return monthlyBudget > 0 ? min(totalExpenses / monthlyBudget, 1.0) : 0
    }
    
    func getExpensesByCategory() -> [ExpenseCategory: Double] {
        let currentMonthExpenses = getCurrentMonthExpenses().filter { $0.type == .expense }
        
        var categoryTotals: [ExpenseCategory: Double] = [:]
        
        for expense in currentMonthExpenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        return categoryTotals
    }
}
