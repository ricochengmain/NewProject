//
//  ViewController.swift
//  KeyFinder
//
//  Created by NeferUser on 2024/12/11.
//

import UIKit

class ViewController: UIViewController {

    let numberPickerView = BFNumberPickerView.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width * 0.6, height: 50), number: Int.random(in: 0...9999999999), font: UIFont.systemFont(ofSize: 24, weight: .bold))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(numberPickerView)
        numberPickerView.backgroundColor = UIColor.systemRed
        
        let randomButton = UIButton(type: .system)
        randomButton.setTitle("隨機數字", for: .normal)
        randomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        randomButton.backgroundColor = UIColor.systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 8
        randomButton.frame = CGRect(x: 50, y: 200, width: 150, height: 50)
        randomButton.addTarget(self, action: #selector(generateRandomNumber), for: .touchUpInside)
        
        view.addSubview(randomButton)
        self.generateRandomNumber()
    }

    @objc private func generateRandomNumber() {
        let randomNum = Int.random(in: 0...9999999999) // 生成 10 位隨機數
        numberPickerView.number = randomNum // 更新數字顯示
    }
}
