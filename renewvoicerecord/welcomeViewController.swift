//
//  welcomeViewController.swift
//  renewvoicerecord
//
//  Created by Kylee on 2018. 1. 31..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
// setting for button and label
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var tokenLb: UILabel!
    @IBOutlet weak var phoneTypeLbl: UILabel!
    @IBOutlet weak var pickerviewBar: UIPickerView!
    
    @IBOutlet weak var questionLbl: UILabel!
    //픽커뷰의 디폴트값 설정 및 데이터 나열
    var phoneSelected:String = "iphone 5"
    let pickerPhoneData:[String] = ["iphone 5", "iphone 5s","iphone 6", "iphone 6s","iphone 6s Plus","iphone 7","iphone 7 plus", "iphone 8","iphone 8 plus","iphone SE", "iphone X"]
    // 픽커뷰를 쓰기위한 설정 + 픽커뷰의 데이터를 순서대로 나열 후 문자열로 출력하게함. UIPickerViewDelegate & UIPickerViewData 들을 사용하기 위한 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
            return pickerPhoneData.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerPhoneData[row]
    }
    //고른 정보를 라벨에 출력
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        phoneSelected = pickerPhoneData[pickerView.selectedRow(inComponent: 0)]
       phoneTypeLbl.text = "제 핸드폰은 \(phoneSelected)입니다"
        self.phoneSelected = pickerPhoneData[pickerView.selectedRow(inComponent: 0)]
    }
    //set varialbe to get info from 
    var welcomeuser = String()
    var getToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerviewBar.delegate = self
        self.pickerviewBar.dataSource = self
        
        print("getToken is \(getToken)")
        
        tokenLb.text = getToken
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  //기기정보를 리코드뷰로 넘겨줌
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var recordViewController = segue.destination as! recordViewController
//       recordViewController.iphonetype = phoneSelected
//    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
//         let vc = recordViewController(nibName: "recoredViewController", bundle: nil)
//        vc.iphonetype = phoneSelected
        let preferences =  UserDefaults.standard
        preferences.set(phoneSelected, forKey: "phonetype")
    }
    
    
    

}

