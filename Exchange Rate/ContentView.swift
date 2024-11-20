//
//  ContentView.swift
//  Exchange Rate
//
//  Created by 翁子翔 on 2024/10/19.
//

import SwiftUI

struct ContentView: View {
    // 匯率
    let exchangeRates: [String: Double] = [
        "TWD": 1.0,
        "USD": 0.032, // TWD to USD
        "JPY": 4.68,  // TWD to JPY
        "KRW": 42.61, // TWD to KRW
        "CNY": 0.22,  // TWD to CNY
        "EUR": 0.028, // TWD to EUR
        "GBP": 0.024  // TWD to GBP
    ]
    // 儲存輸入值
    @State private var amounts: [String: String] = [
        "TWD": "",
        "USD": "",
        "JPY": "",
        "KRW": "",
        "CNY": "",
        "EUR": "",
        "GBP": ""
    ]
    var body: some View {
        List {
            // 根據首字母進行分組
            ForEach(groupByFirstLetter().sorted { $0.key < $1.key }, id: \.key) { letter, currencies in
                Section(header: Text(letter)) {
                    ForEach(currencies, id: \.self) { currency in
                        HStack {
                            Image(currency)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 20)
                                .shadow(radius: 1)
                            Text(currency)
                            TextField("0.00", text: Binding(// 輸入框
                                get: { amounts[currency, default: ""] }, // 目前貨幣的值
                                set: { newValue in // 輸入新值
                                    amounts[currency] = newValue
                                    updateAmounts(for: currency, newValue: newValue)
                                }
                            ))
                            .keyboardType(.decimalPad) // 鍵盤為小數輸入
                            .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
        }
    }
    // 首字母對貨幣分組
    private func groupByFirstLetter() -> [String: [String]] {
        var groupedCurrencies: [String: [String]] = [:]
        for currency in exchangeRates.keys.sorted() {
            groupedCurrencies[String(currency.prefix(1)), default: []].append(currency)
        }
        return groupedCurrencies
    }
    // 更新其他貨幣
    private func updateAmounts(for currency: String, newValue: String?) {
        guard let amountString = newValue, let amount = Double(amountString) else {
            // 輸入無效，清空其他貨幣的值
            for key in exchangeRates.keys {
                if key != currency {
                    amounts[key] = ""
                }
            }
            return
        }
        // 更新其他幣種的值
        for (key, rate) in exchangeRates {
            if key != currency {
                amounts[key] = String(format: "%.2f", amount / exchangeRates[currency]! * rate)
            }
        }
    }
}

#Preview {
    ContentView()
}
