//
//  ContentView.swift
//  CalculatorApp
//
//  Created by Chinmay S Nawkar on 18/07/23.
//

import SwiftUI

enum AngleUnit {
    case rad, deg
}

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case sine = "sin"
    case cosine = "cos"
    case tangent = "tan"
    case rad = "RAD"
    case deg = "DEG"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .percent:
            return Color(.lightGray)
        case .rad, .deg:
            return .orange
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none, sine, cosine, tangent
}

struct ContentView: View {
    @State private var value = "0"
    @State private var runningNumber = 0
    @State private var currentOperation: Operation = .none
    @State private var angleUnit: AngleUnit = .deg // Default angle unit is degrees

    let buttons: [[CalcButton]] = [
        [.sine, .cosine, .tangent, .rad],
        [.clear, .divide, .multiply, .subtract],
        [.seven, .eight, .nine, .add],
        [.four, .five, .six, .deg],
        [.one, .two, .three, .equal],
        [.zero, .decimal, .percent],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Text display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()

                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self.rawValue) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
            }
            self.value = "0"

        case .equal:
            let runningValue = self.runningNumber
            let currentValue = Int(self.value) ?? 0
            switch self.currentOperation {
            case .add: self.value = "\(runningValue + currentValue)"
            case .subtract: self.value = "\(runningValue - currentValue)"
            case .multiply: self.value = "\(runningValue * currentValue)"
            case .divide: self.value = "\(runningValue / currentValue)"
            case .none, .sine, .cosine, .tangent:
                break
            }
            self.currentOperation = .none

        case .sine, .cosine, .tangent:
            let currentValue = Double(value) ?? 0.0
            let result: Double
            switch button {
            case .sine:
                result = angleUnit == .rad ? sin(currentValue) : sin((currentValue * .pi) / 180.0)
            case .cosine:
                result = angleUnit == .rad ? cos(currentValue) : cos((currentValue * .pi) / 180.0)
            case .tangent:
                result = angleUnit == .rad ? tan(currentValue) : tan((currentValue * .pi) / 180.0)
            default:
                result = 0.0
            }
            self.value = "\(result)"

        case .rad:
            angleUnit = .rad

        case .deg:
            angleUnit = .deg

        case .clear:
            self.value = "0"
            self.runningNumber = 0
            self.currentOperation = .none

        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            } else {
                self.value = "\(self.value)\(number)"
            }
        }
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
