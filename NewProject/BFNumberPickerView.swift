//
//  BFNumberPickerView.swift
//  NewProject
//
//  Created by NeferUser on 2025/2/13.
//

import UIKit
import SnapKit

class BFNumberPickerView: UIView {
    
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
    
    convenience init(frame: CGRect, font: UIFont) {
        self.init(frame: frame)
        pickerFont = font
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var pickerFont: UIFont?
    
    private func initSubviews(number: Int) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let formattedNumber = formatNumberWithCommas(number)
        
        var x: CGFloat = 0
        var digitIndex = formattedNumber.filter { $0.isNumber }.count // 最高位數字的索引
        
        let font: UIFont = pickerFont!
        let text = "9"
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = text.size(withAttributes: attributes)
        let width: CGFloat = size.width * 2
        let height: CGFloat = size.height * 2
        let separatorAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemYellow, // 設定顏色
            .font: UIFont.systemFont(ofSize: 24) // 設定字體
        ]
        
        for char in formattedNumber {
            if char.wholeNumberValue != nil {
                let pickerSubView = BFNumberPickerSubView.init(frame: CGRect(x: x, y: 0, width: width, height: height), font: pickerFont!)
                pickerSubView.backgroundColor = UIColor.clear
                pickerSubView.tag = digitIndex // 設置 tag，確保從最高位到最低位
                pickerSubView.selectRow(index: 0)
                digitIndex -= 1 // 更新 tag 為下一個數字
                addSubview(pickerSubView)
                x += pickerSubView.frame.width - size.width
            } else if char == "," {
                let numberPickerSubView: BFNumberPickerSubView = self.subviews.last as! BFNumberPickerSubView
                let rowHeight = numberPickerSubView.pickerView.rowSize(forComponent: 0).height
                let pickerHeight = numberPickerSubView.bounds.height
                let maskHeight = (pickerHeight - rowHeight) / 2
                
                x += (size.width / 2)
                let separatorLabel = UILabel()
                separatorLabel.backgroundColor = UIColor.clear
                separatorLabel.attributedText = NSAttributedString(string: String(char), attributes: separatorAttributes)
                separatorLabel.sizeToFit()
                separatorLabel.frame = CGRect(x: x, y: height - maskHeight - separatorLabel.frame.height, width: separatorLabel.frame.width, height: separatorLabel.frame.height)
                separatorLabel.contentMode = .bottom
                addSubview(separatorLabel)
                x = separatorLabel.frame.maxX - (size.width / 2)
            }
        }
        
        if ((self.subviews.last?.frame.maxX)! - self.frame.size.width > 10 && pickerFont!.pointSize > 24) {
            let smallerFont = pickerFont!.withSize(pickerFont!.pointSize - 1)
            pickerFont = smallerFont
            initSubviews(number: number)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.number = number
            }
            
            self.frame.size.width = self.subviews.last?.frame.maxX ?? 0
            self.frame.size.height = self.subviews.last?.frame.maxY ?? 0
            
            if let superview = self.superview {
                let centerX = (superview.frame.width - self.frame.width) / 2
                self.frame.origin.x = centerX
            }
        }
    }
    
    private func formatNumberWithCommas(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

class BFNumberPickerSubView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var pickerFont: UIFont?
    fileprivate let pickerView = UIPickerView()
    private let numbers = Array(0...9).map { String($0) }
    
    private let topMask = UIView()
    private let bottomMask = UIView()
    
    convenience init(frame: CGRect, font: UIFont) {
        self.init(frame: frame)
        pickerFont = font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        pickerView.frame = self.bounds
        
        setupMaskViews()
        
        DispatchQueue.main.async {
            if let overlay = self.pickerView.subviews.last {
                overlay.backgroundColor = UIColor.clear
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMaskViews() {
        topMask.isUserInteractionEnabled = false
        bottomMask.isUserInteractionEnabled = false
        addSubview(topMask)
        addSubview(bottomMask)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topMask.backgroundColor = self.superview?.backgroundColor
        bottomMask.backgroundColor = self.superview?.backgroundColor
        
        let rowHeight = pickerView.rowSize(forComponent: 0).height
        let pickerHeight = pickerView.bounds.height
        let maskHeight = (pickerHeight - rowHeight) / 2
        
        topMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: maskHeight)
        bottomMask.frame = CGRect(x: 0, y: pickerHeight - maskHeight, width: self.bounds.width, height: maskHeight)
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count * 10 // 讓滾動更流暢
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row % numbers.count]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(numbers[row % numbers.count])")
    }
    
    internal func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.width
    }
    
    internal func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemYellow,
            .font: pickerFont!
        ]
        let text = numbers[row % numbers.count]
        return NSAttributedString(string: text, attributes: pickerAttributes)
    }
    
    @objc fileprivate  func selectRow(index: Int) {
        let middleIndex = index + numbers.count * 5
        pickerView.selectRow(middleIndex, inComponent: 0, animated: true)
    }
}
