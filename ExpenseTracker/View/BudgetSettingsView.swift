//
//  BudgetSettingsView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct BudgetSettingsView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var monthlyBudgetText: String = ""
    @State private var categoryBudgets: [ExpenseCategory: String] = [:]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Monthly Budget")) {
                    HStack {
                        Text("Total Monthly Budget")
                        Spacer()
                        TextField("2000.00", text: $monthlyBudgetText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Text("This is your overall spending limit for the month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Category Budgets")) {
                    ForEach(ExpenseCategory.allCases, id: \.self) { category in
                        if category != .salary && category != .freelance && category != .investment {
                            CategoryBudgetRow(
                                category: category,
                                budgetText: Binding(
                                    get: { categoryBudgets[category] ?? "" },
                                    set: { categoryBudgets[category] = $0 }
                                )
                            )
                        }
                    }
                    
                    Text("Set spending limits for each category to better track your expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button("Reset to Defaults") {
                        resetToDefaults()
                    }
                    .foregroundColor(.orange)
                }
            }
            .navigationTitle("Budget Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBudgets()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadCurrentBudgets()
        }
    }
    
    private func loadCurrentBudgets() {
        monthlyBudgetText = String(expenseViewModel.monthlyBudget)
        
        for category in ExpenseCategory.allCases {
            if category != .salary && category != .freelance && category != .investment {
                categoryBudgets[category] = String(expenseViewModel.getBudgetForCategory(category))
            }
        }
    }
    
    private func saveBudgets() {
        // Save monthly budget
        if let monthlyBudget = Double(monthlyBudgetText) {
            expenseViewModel.monthlyBudget = monthlyBudget
        }
        
        // Save category budgets
        for (category, budgetText) in categoryBudgets {
            if let budget = Double(budgetText) {
                expenseViewModel.budgets[category] = budget
            }
        }
    }
    
    private func resetToDefaults() {
        monthlyBudgetText = "2000.0"
        expenseViewModel.setupDefaultBudgets()
        loadCurrentBudgets()
    }
}

struct CategoryBudgetRow: View {
    let category: ExpenseCategory
    @Binding var budgetText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundColor(category.color)
                .frame(width: 25)
            
            Text(category.rawValue)
                .font(.body)
            
            Spacer()
            
            TextField("0.00", text: $budgetText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
        }
    }
}

#Preview {
    BudgetSettingsView()
        .environmentObject(ExpenseViewModel())
}
