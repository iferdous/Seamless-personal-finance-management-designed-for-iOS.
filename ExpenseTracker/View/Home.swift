//
//  Home.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct Home: View {
    
    @StateObject var expenseViewModel = ExpenseViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                
                // Header
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(isDarkMode ? .white.opacity(0.7) : .gray)
                        
                        Text("iferdous001")
                            .font(.title2.bold())
                            .foregroundColor(isDarkMode ? .white : .primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Budget Button
                    NavigationLink {
                        BudgetView()
                            .environmentObject(expenseViewModel)
                    } label: {
                        Image(systemName: "chart.pie.fill")
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
                    
                    // Filter Button
                    NavigationLink {
                        FilteredDetailView()
                            .environmentObject(expenseViewModel)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
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
                }
                .padding(.horizontal)
                
                // Expense Card
                ExpenseCardView()
                
                // Quick Actions
                QuickActionsView()
                
                // Transactions
                TransactionsView()
                
                // Dark Mode Toggle (Bottom Right)
                HStack {
                    Spacer()
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundColor(isDarkMode ? .yellow : .blue)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(isDarkMode ? Color.gray.opacity(0.3) : Color.white)
                                    .shadow(color: isDarkMode ? .white.opacity(0.2) : .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                    }
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            .padding()
        }
        .background {
            (isDarkMode ? Color.black : Color("BG"))
                .ignoresSafeArea()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $expenseViewModel.showAddExpenseSheet) {
            AddExpenseView()
                .environmentObject(expenseViewModel)
        }
        .sheet(isPresented: $expenseViewModel.showBudgetSettings) {
            BudgetSettingsView()
                .environmentObject(expenseViewModel)
        }
    }
    
    // MARK: - Quick Actions View
    @ViewBuilder
    func QuickActionsView() -> some View {
        HStack(spacing: 20) {
            // Add Expense Button
            Button {
                expenseViewModel.showAddExpenseSheet = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("Add Expense")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 80)
                .padding(.vertical, 15)
                .background(Color.green)
                .cornerRadius(16)
            }
            
            // View Budget Button
            NavigationLink {
                BudgetView()
                    .environmentObject(expenseViewModel)
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .font(.title)
                    Text("Budget")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 80)
                .padding(.vertical, 15)
                .background(Color.blue)
                .cornerRadius(16)
            }
            
            // Budget Settings Button
            Button {
                expenseViewModel.showBudgetSettings = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "gear")
                        .font(.title)
                    Text("Settings")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 80)
                .padding(.vertical, 15)
                .background(Color.orange)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Transactions View
    @ViewBuilder
    func TransactionsView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Transactions")
                    .font(.title2.bold())
                    .foregroundColor(isDarkMode ? .white : .primary)
                    .opacity(0.8)
                
                Spacer()
                
                NavigationLink {
                    FilteredDetailView()
                        .environmentObject(expenseViewModel)
                } label: {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            ForEach(expenseViewModel.getFilteredExpenses().prefix(5), id: \.id) { expense in
                TransactionCardView(expense: expense)
                    .environmentObject(expenseViewModel)
            }
            
            if expenseViewModel.getFilteredExpenses().isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(isDarkMode ? .white.opacity(0.6) : .gray)
                    
                    Text("No transactions yet")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white.opacity(0.8) : .gray)
                    
                    Text("Tap 'Add Expense' to get started")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? .white.opacity(0.6) : .gray)
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .padding()
                .background(isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                .cornerRadius(12)
            }
        }
        .padding(.top)
    }
    
    // MARK: - Expense Card View
    @ViewBuilder
    func ExpenseCardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.pink,
                            Color.orange,
                            Color.blue
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomLeading
                    )
                )
            
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    Text(expenseViewModel.currentMonthDateString())
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    let netAmount = expenseViewModel.getTotalIncome() - expenseViewModel.getTotalExpenses()
                    Text(expenseViewModel.convertNumberToPrice(value: netAmount))
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.bottom, 15)
                }
                .offset(y: -5)
                
                HStack(spacing: 20) {
                    Image(systemName: "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(Color.green)
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.7), in: Circle())
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Income")
                            .font(.caption)
                            .opacity(0.8)
                            .foregroundColor(.white)
                        Text(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getTotalIncome()))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "arrow.up")
                        .font(.caption.bold())
                        .foregroundColor(Color.red)
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.7), in: Circle())
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Expenses")
                            .font(.caption)
                            .opacity(0.8)
                            .foregroundColor(.white)
                        Text(expenseViewModel.convertNumberToPrice(value: expenseViewModel.getTotalExpenses()))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .frame(height: 240)
    }
}
