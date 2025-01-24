//
//  SalaryCalculatorScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 12/26/23.
//

import SwiftUI

enum PaymentFrequency: CaseIterable, Identifiable {
    case hourly
    case weekly
    case biweekly
    case montly
    case yearly
    
    var id: String {
        String(reflecting: self)
    }
    
    var stringValue: String {
        String(describing: self)
    }
}

struct SalaryCalculatorScreen: View {
    
    //MARK: EnvironmentObject
    @EnvironmentObject var themeColor: ThemeColor
    
    @State private var grossSalary: Double = 0.0
    @State private var deductions: Double = 0.0
    
    @State private var frequency = PaymentFrequency.montly
    
    var netSalary: Double {
        let taxableIncome = grossSalary - deductions
        let incomeTax = calculateIncomeTax(taxableIncome: taxableIncome)
        let netSalary = taxableIncome - incomeTax
        return netSalary
    }
    
    var incomeTax: Double {
        let taxableIncome = grossSalary - deductions
        let incomeTax = calculateIncomeTax(taxableIncome: taxableIncome)
        return incomeTax
    }

    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Salary ")) {
                    Picker(selection: $frequency, label: Text("Frequency".localized())) {
                        ForEach(PaymentFrequency.allCases, id: \.self) { freq in
                            Text(freq.stringValue)
                        }
                    }
                    .tint(themeColor.button)
                    .onChange(of: frequency) { frequency in
                        print(frequency)
                    }
                }
                
                Section(header: Text("Gross Yearly Salary")) {
                    TextField("Enter Gross Salary", value: $grossSalary, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Deductions")) {
                    TextField("Enter Deductions", value: $deductions, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Net Taxes")) {
                    Text("- $\(incomeTax, specifier: "%.2f")")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .opacity(0.85)
                }
                
                Section(header: Text("Net Salary")) {
                    Text("$\(netSalary, specifier: "%.2f")")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Salary Calculator")
        }
    }

    // Function to calculate income tax based on the provided formula
    func calculateIncomeTax(taxableIncome: Double) -> Double {
        let taxSlabs: [Double] = [0, 18200, 45000, 120000, 180000]
        let taxRates: [Double] = [0, 0.19, 0.325, 0.37, 0.45]

        var tax = 0.0
        var remainingIncome = taxableIncome

        for i in 1..<taxSlabs.count {
            let slab = min(remainingIncome, taxSlabs[i] - taxSlabs[i - 1])
            tax += slab * taxRates[i]
            remainingIncome -= slab

            if remainingIncome <= 0 {
                break
            }
        }

        return tax
    }
}

#Preview {
    SalaryCalculatorScreen()
        .environmentObject(ThemeColor(appTheme: AppTheme.light.rawValue))
}
