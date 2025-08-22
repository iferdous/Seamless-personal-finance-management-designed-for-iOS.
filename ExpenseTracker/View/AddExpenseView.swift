//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var remark = ""
    @State private var amount = ""
    @State private var selectedType: ExpenseType = .expense
    @State private var selectedCategory: ExpenseCategory = .other
    @State private var selectedDate = Date()
    @State private var selectedColor = Color.blue
    
    private let colorPalette: [[Color]] = [
        [.red, .pink, .purple, .indigo],
        [.blue, .cyan, .teal, .mint],
        [.green, .yellow, .orange, .brown],
        [.gray, .black, Color(red: 0.9, green: 0.9, blue: 0.9), Color(red: 0.5, green: 0.5, blue: 0.5)]
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Description", text: $remark)
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach([ExpenseType.income, ExpenseType.expense], id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("Category")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                Section(header: Text("Color Palette")) {
                    VStack(spacing: 15) {
                        // Selected Color Preview
                        HStack {
                            Text("Selected Color:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Circle()
                                .fill(selectedColor)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 2)
                                )
                        }
                        
                        // Color Palette Grid
                        VStack(spacing: 12) {
                            ForEach(0..<colorPalette.count, id: \.self) { row in
                                HStack(spacing: 12) {
                                    ForEach(0..<colorPalette[row].count, id: \.self) { col in
                                        let color = colorPalette[row][col]
                                        ColorPaletteButton(
                                            color: color,
                                            isSelected: selectedColor == color
                                        ) {
                                            selectedColor = color
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Custom Color Picker
                        ColorPicker("Custom Color", selection: $selectedColor)
                            .labelsHidden()
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(remark.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amountDouble = Double(amount) else { return }
        
        let newExpense = Expense(
            remark: remark,
            amount: amountDouble,
            date: selectedDate,
            type: selectedType,
            color: colorToString(selectedColor),
            category: selectedCategory
        )
        
        expenseViewModel.addExpense(newExpense)
        dismiss()
    }
    
    private func colorToString(_ color: Color) -> String {
        // Convert Color to a string representation for storage
        if color == .red { return "Red" }
        else if color == .pink { return "Pink" }
        else if color == .purple { return "Purple" }
        else if color == .indigo { return "Indigo" }
        else if color == .blue { return "Blue" }
        else if color == .cyan { return "Cyan" }
        else if color == .teal { return "Teal" }
        else if color == .mint { return "Mint" }
        else if color == .green { return "Green" }
        else if color == .yellow { return "Yellow" }
        else if color == .orange { return "Orange" }
        else if color == .brown { return "Brown" }
        else if color == .gray { return "Gray" }
        else if color == .black { return "Black" }
        else { return "Custom" }
    }
}

struct CategoryButton: View {
    let category: ExpenseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isSelected ? category.color : category.color.opacity(0.2))
                    )
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? category.color : .primary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorPaletteButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: isSelected ? 3 : 1)
                        .opacity(isSelected ? 1 : 0.3)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .shadow(color: color.opacity(0.5), radius: isSelected ? 5 : 2, x: 0, y: 2)
                .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorButton: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(color))
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: isSelected ? 3 : 0)
                )
                .scaleEffect(isSelected ? 1.2 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(ExpenseViewModel())
}
