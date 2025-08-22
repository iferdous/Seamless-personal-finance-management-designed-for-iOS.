//
//  TransactionCardView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct TransactionCardView: View {
    
    var expense: Expense
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Category Icon with custom color
            ZStack {
                Circle()
                    .fill(Color.fromString(expense.color))
                    .frame(width: 50, height: 50)
                
                Image(systemName: expense.category.icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .shadow(color: Color.fromString(expense.color).opacity(0.3), radius: 3, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.remark)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(expense.category.color.opacity(0.2))
                        .foregroundColor(expense.category.color)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(expense.date.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                // Amount with +/- indicator
                HStack(spacing: 2) {
                    Text(expense.type == .income ? "+" : "-")
                        .font(.callout.bold())
                        .foregroundColor(expense.type == .income ? .green : .red)
                    
                    Text(expenseViewModel.convertNumberToPrice(value: expense.amount))
                        .font(.callout.bold())
                        .foregroundColor(expense.type == .income ? .green : .red)
                }
                
                Text(expense.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(expense.type == .income ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(expense.type == .income ? .green : .red)
                    .cornerRadius(6)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .contextMenu {
            Button {
                expenseViewModel.deleteExpense(expense)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    TransactionCardView(expense: sample_expenses[0])
        .environmentObject(ExpenseViewModel())
        .padding()
}
