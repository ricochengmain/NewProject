//
//  ViewController.swift
//  KeyFinder
//
//  Created by NeferUser on 2024/12/11.
//

import UIKit

class ViewController: UIViewController {
    
    let baseView = UIView()
    var numberPickerView: BFNumberPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemRed
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.5)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.systemBlue
    
        numberPickerView = BFNumberPickerView()
        baseView.addSubview(numberPickerView!)
        numberPickerView!.backgroundColor = numberPickerView?.superview!.backgroundColor
        
        let randomButton = UIButton(type: .system)
        randomButton.setTitle("0123456789", for: .normal)
        randomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        randomButton.backgroundColor = UIColor.systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 8
        randomButton.frame = CGRect(x: 50, y: 200, width: 150, height: 50)
        randomButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 18)
        randomButton.addTarget(self, action: #selector(generateRandomNumber), for: .touchUpInside)
//        UIFont(name: "Verdana-Bold", size: 18)
        view.addSubview(randomButton)
        self.generateRandomNumber()
    }

    @objc private func generateRandomNumber() {
        let randomNum = Int.random(in: 0...9999999999) // 生成 10 位隨機數
        numberPickerView!.number = randomNum // 更新數字顯示
    }
}
