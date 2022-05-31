//
//  ContentView.swift
//  WeSplit
//
//  Created by whybhav on 19/05/22.
//
import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @State private var useRedText = false
    
    @FocusState private var amountIsSelected: Bool
    
    var currencyPreference: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "INR")
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2) //because we loop from 2, and numberOfPeople = 2 actually means 4 people in the UI so we add 2 to it to make the value also equal to 4
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyPreference)
                        .keyboardType(.decimalPad)
                        .focused($amountIsSelected)
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalAmount, format: currencyPreference)
                        .foregroundColor(isTipZero() ? .red : .black)
                } header: {
                    Text("Total Amount")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "INR"))
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsSelected = false
                    }
                }
            }
        }
    }
    
    func isTipZero() -> Bool {
        var viewColor = useRedText
        if tipPercentage == 0 {
            viewColor.toggle()
        }
        return viewColor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
