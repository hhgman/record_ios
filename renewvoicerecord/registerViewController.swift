//
//  registerViewController.swift
//  renewvoicerecord
//
//  Created by Kylee on 2018. 1. 31..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit
import Alamofire

class registerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 메인스토리보드 위젯들과 스위프트 파일을 연결(변수선언)
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repaetpasswordTextField: UITextField!
    @IBOutlet weak var IDNOTextfield: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    @IBOutlet weak var registerErrorLb: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var IdnoLbl: UILabel!
    
    //픽커뷰에 쓰이는 변수 선언
    let pickerData = Array(arrayLiteral: "남성", "여성")
    let ageList = Array(1920...2018)
    var year = "1920"
    var gender = "남성"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
    }
    
    // 픽커뷰를 쓰기위한 설정 + 픽커뷰의 데이터를 순서대로 나열 후 문자열로 출력하게함. 마지막으로 UIPickerViewDelegate & UIPickerViewData 들을 사용하기 위한 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return pickerData.count
        }
        return ageList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return pickerData[row]
        }
        return "\(ageList[row])"
    }
    
    //픽커뷰에서 고른 자료들을 라벨에 출력되게함
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        
        let genderSelected = pickerData[pickerView.selectedRow(inComponent: 0)]
        let bornYearSelected = ageList[pickerView.selectedRow(inComponent: 1)]
        genderLbl.text = "나는 \(genderSelected)이고 \(bornYearSelected)에 태어났습니다."
        
        gender = genderSelected
        year = "\(bornYearSelected)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        //변수설정
        let username :String? = usernameTextField.text
        let password :String? = passwordTextField.text
        let repeatpassword :String? = repaetpasswordTextField.text
        let Idno : String? = IDNOTextfield.text
        let name :String? = nameTextField.text
        //check for any  empty space in the user or password field
        
        if (username == nil || password == nil || repeatpassword == nil){
            registerBtn.isEnabled = false
        }
        
        if (password != repeatpassword)
        {
            //            displayMyAlertMessage(userMessage: "Passwords do not match")
            registerErrorLb.text = "비밀번호가 일치하지 않습니다."
            return;
        }
        else {
            performSegue(withIdentifier: "goToLogin", sender: self)
            //            let url = URL(string: "http://localhost:8000/join/")
            //             학교연구실
            let url = URL(string: "http://165.132.120.188:8000/join/")
            //             인천집
            //            let url = URL(string: "http://192.168.123.171:8000/join/")
            //              서울집
            //            let url = URL(string: "http://192.168.0.198:8000/join/")
            //             인턴실구실
            //            let url = URL(string: "http://172.24.118.202:8000/join/")
       
            let json = [
                "username": username!,
                "password": password!,
                "birth": year,
                "gender": gender,
                "id_number": Idno!,
                "name" : name!
                ] as [String : Any]
            
            Alamofire.request(url!,method: .post, parameters: json)
            print(json)
            print("Success")
        }
    }
}
