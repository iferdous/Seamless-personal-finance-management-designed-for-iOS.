//
//  FilteredDetailView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/9/25.
//

import SwiftUI

struct FilteredDetailView: View {

    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                
                // Header
                HStack(spacing: 15) {
                    
                    // Back Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.blue)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                    
                    // Title
                    Text("All Transactions")
                        .font(.title2.bold())
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Filter Button
                    Button {
                        expenseViewModel.showFilterSheet = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.purple)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                    
                    // Add Button
                    Button {
                        expenseViewModel.showAddExpenseSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.green)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                }
                .padding(.horizontal)
                
                // Filter Pills
                FilterPillsView()
                
                // Transaction Summary
                TransactionSummaryView()
                
                // Transaction List
                TransactionListView()
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .sheet(isPresented: $expenseViewModel.showFilterSheet) {
            FilterBottomSheet()
                .environmentObject(expenseViewModel)
        }
        .sheet(isPresented: $expenseViewModel.showAddExpenseSheet) {
            AddExpenseView()
                .environmentObject(expenseViewModel)
        }
    }
    
    // MARK: - Filter Pills View
    @ViewBuilder
    func FilterPillsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ExpenseType.allCases, id: \.self) { type in
                    FilterPill(
                        title: type.rawValue,
                        isSelected: expenseViewModel.selectedType == type
                    ) {
                        expenseViewModel.selectedType = type
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Transaction Summary View
    @ViewBuilder
    func TransactionSummaryView() -> some View {
        HStack(spacing: 15) {
            SummaryCard(
                title: "Income",
                amount: expenseViewModel.getTotalIncome(),
                color: .green,
                icon: "arrow.down"
            )
            
            SummaryCard(
                title: "Expenses",
                amount: expenseViewModel.getTotalExpenses(),
                color: .red,
                icon: "arrow.up"
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Transaction List View
    @ViewBuilder
    func TransactionListView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Transactions")
                    .font(.title2.bold())
                    .opacity(0.7)
                
                Spacer()
                
                Text("\(expenseViewModel.getFilteredExpenses().count) items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            LazyVStack(spacing: 12) {
                ForEach(expenseViewModel.getFilteredExpenses(), id: \.id) { expense in
                    TransactionCardView(expense: expense)
                        .environmentObject(expenseViewModel)
                }
            }
            .padding(.horizontal)
            
            if expenseViewModel.getFilteredExpenses().isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No transactions found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Try adjusting your filters or add some transactions")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding()
            }
        }
    }
}

// MARK: - Supporting Views
struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(ExpenseViewModel().convertNumberToPrice(value: amount))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct FilterBottomSheet: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Type Filter
                VStack(alignment: .leading, spacing: 15) {
                    Text("Transaction Type")
                        .font(.headline)
                    
                    Picker("Type", selection: $expenseViewModel.selectedType) {
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Spacer()
                
                // Apply Button
                Button {
                    dismiss()
                } label: {
                    Text("Apply Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("Filter Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    FilteredDetailView()
        .environmentObject(ExpenseViewModel())
}
