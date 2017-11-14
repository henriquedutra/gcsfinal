//
//  MainViewController.swift
//  GCS Final
//
//  Created by Henrique Dutra on 14/11/2017.
//  Copyright © 2017 Henrique Dutra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var tabBarRect: UIView!
    @IBOutlet weak var waveImage: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var restLabel: UILabel!
    
    var round : Int = 1
    var timeLeft : Int = 5
    var timer = Timer()
    
    var status : Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialView()
        self.updateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickButton(_ sender: Any) {
        if(self.status == 0){
            self.runTimer()
            status = 1;
            self.updateIcon()
        }
        else {
            self.timer.invalidate()
            self.timeLeft = 5
            self.updateLabel()
            self.round = 1
            self.updateRoundLabel()
            status = 0
            self.updateIcon()
        }
    }
    
    func updateRoundLabel() {
        self.roundLabel.text = "round " + String(self.round)
    }
    
    @IBAction func didClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupInitialView() {
        
        self.tabBarRect.layer.borderWidth = 1
        self.tabBarRect.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        
        self.icon.image = UIImage(named: "play")
        
    }
    func updateLabel() {
        self.timerLabel.text = self.getTimeFormatted()
    }
    
    func updateIcon (){
        
        if (status == 1){
            self.icon.image = UIImage(named: "stop")
            self.icon.isHidden = false
        }
        else if(status == 0){
            self.icon.image = UIImage(named: "play")
            self.icon.isHidden = false
        }
        else if(status == 2){
            self.icon.isHidden = true
        }
    }
    
    func getTimeFormatted () -> String {
        var format : String = ""
        let minutes = self.timeLeft / 60
        let seconds = self.timeLeft - (minutes * 60)
        
        if(minutes<10){
            format += "0"
        }
        format += String(minutes)
        format += ":"
        if(seconds<10){
            format += "0"
        }
        format += String(seconds)
        
        return format
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func restTime () {
        self.waveImage.image = UIImage(named: "waveGreen")
        self.button.isHidden = true
        self.restLabel.isHidden = false
        self.timeLeft = 5
        self.runTimer()
        self.status = 2
        self.restLabel.text = "Tempo de descanso"
    }
    
    func bigRestTime () {
        self.round = 1
        self.updateRoundLabel()
        self.waveImage.image = UIImage(named: "waveGreen")
        self.button.isHidden = true
        self.restLabel.isHidden = false
        self.restLabel.text = "Fim do seu quarto round, agora o descanso é maior"
        self.timeLeft = 5
        self.runTimer()
        self.status = 2
    }
    
    func endRestTime() {
        self.waveImage.image = UIImage(named: "wave")
        self.button.isHidden = false
        self.restLabel.isHidden = true
        self.timer.invalidate()
        self.timeLeft = 5
        self.updateRoundLabel()
    }
    
    @objc func updateTimer() {
        self.timeLeft -= 1
        if(timeLeft == 0){
            if (status == 1){
                self.timer.invalidate()
                self.round += 1
                self.updateRoundLabel()
                self.status = 0
                self.timeLeft = 5
                self.updateLabel()
                
                if (round == 5){
                    self.bigRestTime()
                }
                else{
                    self.restTime()
                }
            }
            else if(status == 2){
                self.status = 0
                self.endRestTime()
            }
            self.updateIcon()
        }
        self.updateLabel()
    }
}
