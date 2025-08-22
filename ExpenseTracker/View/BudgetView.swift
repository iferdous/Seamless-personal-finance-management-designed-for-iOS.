//
//  BudgetView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text("Budget Overview")
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    // Settings Button
                    Button {
                        expenseViewModel.showBudgetSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                
                // Overall Budget Card
                OverallBudgetCard()
                
                // Category Budgets
                VStack(alignment: .leading, spacing: 15) {
                    Text("Category Budgets")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            if category != .salary && category != .freelance && category != .investment {
                                CategoryBudgetCard(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(Color("BG").ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $expenseViewModel.showBudgetSettings) {
            BudgetSettingsView()
                .environmentObject(expenseViewModel)
        }
    }
    
    @ViewBuilder
    func OverallBudgetCard() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Monthly Budget")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(expenseViewModel.convertNumberToPrice(value: expenseViewModel.monthlyBudget))
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Remaining")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getRemainingBudget()))
                        .font(.title2.bold())
                        .foregroundColor(expenseViewModel.getRemainingBudget() >= 0 ? .green : .red)
                }
            }
            
            // Progress Bar
            ProgressView(value: expenseViewModel.getBudgetProgress())
                .progressViewStyle(LinearProgressViewStyle(tint: expenseViewModel.getBudgetProgress() > 0.8 ? .red : .green))
                .scaleEffect(x: 1, y: 4, anchor: .center)
            
            HStack {
                Text("Spent: \(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getTotalExpenses()))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(Int(expenseViewModel.getBudgetProgress() * 100))%")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct CategoryBudgetCard: View {
    let category: ExpenseCategory
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Category Icon
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(category.color)
                .frame(width: 40, height: 40)
                .background(category.color.opacity(0.2))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(category.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getBudgetForCategory(category)))
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Spent: \(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getSpentForCategory(category)))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    let remaining = expenseViewModel.getBudgetForCategory(category) - expenseViewModel.getSpentForCategory(category)
                    Text("Left: \(expenseViewModel.convertNumberToPrice(value: remaining))")
                        .font(.caption)
                        .foregroundColor(remaining >= 0 ? .green : .red)
                }
                
                // Progress Bar
                ProgressView(value: expenseViewModel.getBudgetProgress(category))
                    .progressViewStyle(LinearProgressViewStyle(tint: expenseViewModel.getBudgetProgress(category) > 0.8 ? .red : category.color))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    BudgetView()
        .environmentObject(ExpenseViewModel())
}
