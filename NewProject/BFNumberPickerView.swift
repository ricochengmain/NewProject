//
//  BFNumberPickerView.swift
//  NewProject
//
//  Created by NeferUser on 2025/2/13.
//

import UIKit
import SnapKit

class BFNumberPickerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var number: Int = 0 {
        didSet {
            let formattedNumber = formatNumberWithCommas(number)
            let newDigitCount = formattedNumber.filter { $0.isNumber }.count
            let oldDigitCount = self.subviews.filter { $0 is BFNumberPickerSubView }.count
            
            // 如果位數不同，清除所有 subview，重新初始化
            if newDigitCount != oldDigitCount {
                self.subviews.forEach { $0.removeFromSuperview() }
                initSubviews(number: number)
                return
            }
            
            // 更新數字
            var digitIndex = newDigitCount // 從最高位數開始
            for char in formattedNumber {
                if let digit = char.wholeNumberValue {
                    if let pickerSubView = self.viewWithTag(digitIndex) as? BFNumberPickerSubView {
                        pickerSubView.selectRow(index: digit) // 設置數字對應的 row
                    }
                    digitIndex -= 1 // 移動到下一位數
                }
            }
        }
    }
    
    private func initSubviews(number: Int) {
        let formattedNumber = formatNumberWithCommas(number)
        
        var x: CGFloat = 0
        var digitIndex = formattedNumber.filter { $0.isNumber }.count // 最高位數字的索引
        
        for char in formattedNumber {
            if char.wholeNumberValue != nil {
                let pickerSubView = BFNumberPickerSubView(frame: CGRect(x: x, y: 0, width: 50, height: 50))
                pickerSubView.tag = digitIndex // 設置 tag，確保從最高位到最低位
                pickerSubView.selectRow(index: 0)
                digitIndex -= 1 // 更新 tag 為下一個數字
                addSubview(pickerSubView)
                x += pickerSubView.frame.width - 36
            } else if char == "," {
                x += 18
                let separatorLabel = UILabel()
                separatorLabel.text = String(char)
                separatorLabel.sizeToFit()
                separatorLabel.frame = CGRect(x: x, y: 50 - separatorLabel.frame.height - 10, width: separatorLabel.frame.width, height: separatorLabel.frame.height)
                addSubview(separatorLabel)
                x = separatorLabel.frame.maxX - 18
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.number = number
        }
        self.frame.size.width = self.subviews.last?.frame.maxX ?? 0
        
        if let superview = self.superview {
            let centerX = (superview.frame.width - self.frame.width) / 2
            self.frame.origin.x = centerX
        }
    }
    
    private func formatNumberWithCommas(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

class BFNumberPickerSubView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    let pickerView = UIPickerView()
    let numbers = Array(0...9).map { String($0) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
        pickerView.frame = self.bounds
        
        DispatchQueue.main.async {
            if let overlay = self.pickerView.subviews.last {
                overlay.backgroundColor = UIColor.clear
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count * 10 // 讓滾動更流暢
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row % numbers.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(numbers[row % numbers.count])")
    }
    
    @objc func selectRow(index: Int) {
        let middleIndex = index + numbers.count * 5 // 讓選擇的數字在滾輪中央
        pickerView.selectRow(middleIndex, inComponent: 0, animated: true)
    }
}
