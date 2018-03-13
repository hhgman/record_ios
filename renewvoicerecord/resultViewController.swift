//
//  resultViewController.swift
//  renewvoicerecord
//
//  Created by Kylee on 2018. 1. 31..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit
protocol EditDelegate{
    func didMessageEditdone(_ controller: resultViewController, message: String)
}

class resultViewController: UIViewController {
    //프로그레스바 및 스코어 점수 라벨 변수 설정(메인스토리보드와 스위프트 파일 연결)
    @IBOutlet weak var prbar1: UIProgressView!
    @IBOutlet weak var prbar2: UIProgressView!
    @IBOutlet weak var prbar3: UIProgressView!
    @IBOutlet weak var prbar4: UIProgressView!
    @IBOutlet weak var prbar5: UIProgressView!
    
    @IBOutlet weak var score1Lbl: UILabel!
    @IBOutlet weak var score2Lbl: UILabel!
    @IBOutlet weak var score3Lbl: UILabel!
    @IBOutlet weak var score4Lbl: UILabel!
    @IBOutlet weak var score5Lbl: UILabel!
    
    @IBAction func getResultBtn(_ sender: Any) {
        
        var text1 = UserDefaults.standard.array(forKey:"results")![0] as! Float
        var text2 = UserDefaults.standard.array(forKey:"results")![1] as! Float
        var text3 = UserDefaults.standard.array(forKey:"results")![2] as! Float
        var text4 = UserDefaults.standard.array(forKey:"results")![3] as! Float
        var text5 = UserDefaults.standard.array(forKey:"results")![4] as! Float
        //프로그레스바의 움직임 설정(점수에따른 비율로 움직임)
        prbar1.setProgress(text1/10.0, animated: true)
        prbar2.setProgress(text2/10.0, animated: true)
        prbar3.setProgress(text3/10.0, animated: true)
        prbar4.setProgress(text4/10.0, animated: true)
        prbar5.setProgress(text5/10.0, animated: true)
         //스코어에 리코드뷰에서 넘어온 점수 표기
        score1Lbl?.text = "\(text1)/10.0"
        score2Lbl?.text = "\(text2)/10.0"
        score3Lbl?.text = "\(text3)/10.0"
        score4Lbl?.text = "\(text4)/10.0"
        score5Lbl?.text = "\(text5)/10.0"
        
        text1 = 0.0
        text2 = 0.0
        text3 = 0.0
        text4 = 0.0
        text5 = 0.0
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
