//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Сергей Поляков on 27.01.2024.
//
//  Исключения:
//  1. Если просле кнопки равно нажать кнопку с цифрой, то цифра добавляется к числу
//  2. Если нажать несколько кнопок операций последовательно, то массив calculationHistory формируется неправильно


import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        if buttonText == "," && label.text?.contains(",") == true { return }
        if calculated {
            label.text = "0"
            calculated = false
        }
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard 
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if case .operation(let lastOperation) = calculationHistory.last {
            calculationHistory.removeLast()
            calculationHistory.append(.operation(buttonOperation))
        } else {
            calculationHistory.append(.number(labelNumber))
            calculationHistory.append(.operation(buttonOperation))
        }
        print(calculationHistory)
        resetLabelText()
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        resetLabelText()
    }
   
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Ошибка"
        }
        calculationHistory.removeAll()
        calculated = true
    }
    
    var calculationHistory: [CalculationHistoryItem] = []
    var calculated = false
    
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabelText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        var currentResult = firstNumber
        for index in stride(from: 1, through: calculationHistory.count - 1, by: 2) {
            guard 
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetLabelText() {
        label.text = "0"
    }
}

