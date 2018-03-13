//
//  recordViewController.swift
//  renewvoicerecord
//
//  Created by Kylee on 2018. 1. 31..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

extension String {
    func getEndIndex(of target: String) -> Index? {
        // 찾는 결과는 `leftIndex`와 `rightIndex`사이에 들어가게 된다.
        var leftIndex = startIndex
        while true {
            // 우선 `leftIndex`의 글자가 찾고자하는 target의 첫글자와 일치하는 곳까지 커서를 전진한다.
            guard self[leftIndex] == target[target.startIndex] else {
                leftIndex = index(after:leftIndex)
                if leftIndex >= endIndex { return nil }
                continue
            }
            // `leftIndex`의 글자가 일치하는 곳이후부터 `rightIndex`를 늘려가면서 일치여부를 찾는다.
            var rightIndex = index(after:leftIndex)
            var targetIndex = target.index(after:target.startIndex)
            while self[rightIndex] == target[targetIndex] {
                // target의 전체 구간이 일치함이 확인되는 경우
                guard distance(from:leftIndex, to:rightIndex) < target.characters.count - 1
                    else {
                        //찾은 문자에서
                        return index(after:rightIndex)
                }
                rightIndex = index(after:rightIndex)
                targetIndex = target.index(after:targetIndex)
                // 만약 일치한 구간을 찾지못하고 범위를 벗어나는 경우
                if rightIndex >= endIndex {
                    return nil
                }
                
            }
            leftIndex = index(after:leftIndex)
        }
    }
}

class recordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // 메인스토리보드와 스위프트 파일을 연결 ( 변수 설정 )
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var scrollLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    //녹음 버튼들을 위한 변수설정
    var recordButton = UIButton()
    var playButton = UIButton()
    var isRecording = false
    var audioRecorder: AVAudioRecorder?
    var player : AVAudioPlayer?
    var isPlaying = false
    //타이머 변수설정
    @IBOutlet weak var timerLbl: UILabel!
    var time = 120
    var timer = Timer()
    
    // Adding play button and record button as subviews
    func setUpUI() {
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        view.addSubview(playButton)
        // Adding constraints to Record button
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.topAnchor.constraint(equalTo: positionLbl.bottomAnchor).isActive = true
        let recordButtonHeightConstraint = recordButton.heightAnchor.constraint(equalToConstant: 50)
        recordButtonHeightConstraint.isActive = true
        recordButton.widthAnchor.constraint(equalTo: recordButton.heightAnchor, multiplier: 1.0).isActive = true
        recordButton.setImage(#imageLiteral(resourceName: "recordBtn"), for: .normal)
        recordButton.imageEdgeInsets = UIEdgeInsetsMake(-30, -30, -30, -30)
        recordButton.addTarget(self, action: #selector(record(sender:)), for: .touchUpInside)
        
        // Adding constraints to Play button
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 1.0).isActive = true
        playButton.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: +155).isActive = true
        playButton.centerYAnchor.constraint(equalTo: recordButton.bottomAnchor).isActive = true
        playButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
        playButton.imageEdgeInsets = UIEdgeInsetsMake(-1,-1,-1,-1)
        playButton.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        
        playButton.isEnabled = false
        submitBtn.isEnabled = false
        retryBtn.isEnabled = false
    }
    
    // Path for saving/retreiving the audio file
    func getAudioFileUrl() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.wav")
        return audioUrl
    }
    func startRecording() {
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVLinearPCMBitDepthKey : 16
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            //5. Changing record icon to stop icon
            isRecording = true
            recordButton.setImage(#imageLiteral(resourceName: "stopBtn"), for: .normal)
            recordButton.imageEdgeInsets = UIEdgeInsetsMake(-30, -30, -30, -30)
            playButton.isEnabled = false
            retryBtn.isEnabled = false
            submitBtn.isEnabled = false
            
        }
        catch let error {
            // failed to record!
        }
    }
    //스타트 버튼이 눌려졋을 때 행해지는 함수 설정
    @objc func startAction(){
        //타이머의 시간 움직임 설정
        time -= 1
        if time>=120 {
            timerLbl.text = "02:00"
        }else if time>=60 {
            let min = time-60
            if min>=10{
                timerLbl.text = "01:\(min)"
            }else {
                timerLbl.text = "01:0\(min)"
            }
        }else if time>=0{
            if time>=10{
                timerLbl.text = "00:\(time)"
            }else{
                timerLbl.text = "00:0\(time)"
            }
        }else{
            //finish task
            timer.invalidate()
        }
    }
    //녹음 버튼이 눌러졋을때의 움직임 설정
    @objc func record(sender: UIButton) {
        func finishRecording() {
            //녹음 버튼이 눌러진후 재생버튼이 정지버튼으로 변경 및 크기 설정
            audioRecorder?.stop()
            isRecording = false
            recordButton.imageEdgeInsets = UIEdgeInsetsMake(-30, -30, -30, -30)
            recordButton.setImage(#imageLiteral(resourceName: "recordBtn"), for: .normal)
            
            //타이머 움직임 설정(역방향)
            timer.invalidate()
            time = 120 - time
            if time>=120 {
                timerLbl.text = "02:00"
            }else if time>=60 {
                let min = time-60
                if min>=10{
                    timerLbl.text = "01:\(min)"
                }else {
                    timerLbl.text = "01:0\(min)"
                }
            }else{
                if time>=10{
                    timerLbl.text = "00:\(time)"
                }else{
                    timerLbl.text = "00:0\(time)"
                }
            }
            playButton.isEnabled = true
            retryBtn.isEnabled = true
            submitBtn.isEnabled = true
        }
        
        if isRecording {
            finishRecording()
        }else {
            startRecording()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAction), userInfo: nil, repeats: true)
        }
        //녹음중 발생하는 불시의 상항 대비 정지 설정(전화 등)
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag {
                finishRecording()
            }else {
                // Recording interrupted by other reasons like call coming, reached time limit.
            }
            playButton.isEnabled = true
            retryBtn.isEnabled = true
            submitBtn.isEnabled = true
        }
        
    }
    //재생버튼 액션 설정
    func playSound(){
        //재생버튼이 눌러지면 정지버튼 설정 및 크기 설정
        isPlaying = true
        playButton.setImage(#imageLiteral(resourceName: "stopBtn"), for: .normal)
        playButton.imageEdgeInsets = UIEdgeInsetsMake(-1, -1, -1, -1)
        
        // 타이머 설정 및 녹음 파일이 저장될 경로인 url변수 설정
        let url = getAudioFileUrl()
        time -= 1
        if time>=120 {
            timerLbl.text = "02:00"
        }else if time>=60 {
            let min = time-60
            if min>=10{
                timerLbl.text = "01:\(min)"
            }else {
                timerLbl.text = "01:0\(min)"
            }
        }else if time>0{
            if time>=10{
                timerLbl.text = "00:\(time)"
            }else{
                timerLbl.text = "00:0\(time)"
            }
        }else{
            player?.stop()
            isPlaying = false
            playButton.imageEdgeInsets = UIEdgeInsetsMake(-1, -1, -1, -1)
            playButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            timer.invalidate()
        }
        
        do {
            // AVAudioPlayer setting up with the saved file URL
            let sound = try AVAudioPlayer(contentsOf: url)
            self.player = sound
            
            // Here conforming to AVAudioPlayerDelegate
            sound.delegate = self
            sound.prepareToPlay()
            sound.play()
            recordButton.isEnabled = false
        } catch {
            print("error loading file")
            // couldn't load file :(
        }
    }
    //녹음 버튼이 눌러지는 순간의 동작 설정
    @objc func play(sender: UIButton) {
        
        func finishPlaying() {
            //
            player?.stop()
            isPlaying = false
            playButton.imageEdgeInsets = UIEdgeInsetsMake(-1, -1, -1, -1)
            playButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            timer.invalidate()
            retryBtn.isEnabled = true
            submitBtn.isEnabled = true
        }
        
        if isPlaying{
            finishPlaying()
        }else{
            playSound()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAction), userInfo: nil, repeats: true)
        }
        //재생중 불시상황대비 설정
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if flag {
            }else {
                // Playing interrupted by other reasons like call coming, the sound has not finished playing.
            }
            recordButton.isEnabled = true
        }
    }
    // 재시도 버튼을 눌렀을때 리셋 설정
    func retry(){
        recordButton.isEnabled = true
        playButton.isEnabled = false
        retryBtn.isEnabled = false
        submitBtn.isEnabled = false
        
        timer.invalidate()
        time = 120
        timerLbl.text = "02:00"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let url = URL(string: "http://165.132.120.188:8000/statics/?text/")
            let headers: HTTPHeaders = [
                "Authorization":"Token \(UserDefaults.standard.string(forKey: "access_token")!)",
            ]
            print("alamo")
        Alamofire.request(url!, method: .get, headers: headers).responseString(encoding: String.Encoding.utf8){ response in
                debugPrint(response)
                let str = response.result.value!
                let strmod = str.replacingOccurrences(of: "\\n", with: "\n")
            
                self.scrollLbl.text = String(strmod[strmod.index(strmod.startIndex, offsetBy:9)...strmod.index(strmod.endIndex, offsetBy: -3)])
                print(str)
                print("Success")
                                let start = str.index(str.startIndex, offsetBy: 0)
                                let end = str.index(str.endIndex, offsetBy: -1)
                                let range = start..<end
                                let token = str[range]
            }
        // Do any additional setup after loading the view.
        // Asking user permission for accessing Microphone
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                self.setUpUI()
            } else {
                // User denied microphone. Tell them off!
            }
        }
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: scrollLbl.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retryBtnPressed(_ sender: Any) {
        print("device: \(iphonetype)")
        retry()
    }
 
    func getResult(completion :()->()){
        let headers: HTTPHeaders = [
            "Authorization":"Token \(UserDefaults.standard.string(forKey: "access_token")!)",
            "Content-type":"multipart/form-data",
            ]
        
        print(UserDefaults.standard.string(forKey: "access_token"))
        //        let url = URL(string: "http://localhost:8000/recordings/")
        //        서울집
        //        let url = URL(string: "http://192.168.0.198:8080/recordings/")
        //        인천집
        //        let url = URL(string: "http://192.168.123.171:8000/recordings/")
        //         학교연구실
        let url = URL(string: "http://165.132.120.188:8000/recordings/")
        //         인턴실구실
        //        let url = URL(string: "http://172.24.118.202:8000/recordings/")
        let audioURL = getAudioFileUrl()
        print("audioURL: \(audioURL)")
        iphonetype = UserDefaults.standard.string(forKey: "phonetype")!
        print("iphonetype: \(iphonetype)")


        
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
    
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(audioURL, withName: "datafile" )
                multipartFormData.append(self.iphonetype.data(using: String.Encoding.utf8)!, withName: "device")
                multipartFormData.append(UserDefaults.standard.string(forKey: "gender")!.data(using: String.Encoding.utf8)!, withName: "gender")
                multipartFormData.append(UserDefaults.standard.string(forKey: "birth")!.data(using: String.Encoding.utf8)!, withName: "birth")
                multipartFormData.append(UserDefaults.standard.string(forKey: "name")!.data(using: String.Encoding.utf8)!, withName: "name")
                multipartFormData.append(UserDefaults.standard.string(forKey: "id_number")!.data(using: String.Encoding.utf8)!, withName: "id_number")
//                multipartFormData.append("test".data(using: String.Encoding.utf8)!, withName: "filename")
                multipartFormData.append("\(UserDefaults.standard.string(forKey: "name")!)_".data(using: String.Encoding.utf8)! + "\(UserDefaults.standard.string(forKey: "id_number")!)_".data(using: String.Encoding.utf8)! + "\(UserDefaults.standard.string(forKey: "gender")!)_".data(using: String.Encoding.utf8)! + dateFormatter.string(from: now).data(using: String.Encoding.utf8)! + ".wav".data(using: String.Encoding.utf8)!, withName: "filename")
        },
            to:url!,
            headers:headers,
            encodingCompletion: {encodingResult in
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseString { response in
                        debugPrint(response)
                        
                        let resultString = response.result.value!
                
                        //result 필드의 결과값을 검색하기위해 "result"라는 문자열을 검색하고 마지막 인덱스를 반환
                        let resultIndex = resultString.getEndIndex(of: "result")
                        //결과값들이 들어가는 문자열만을 추출하도록 인덱스를 조정하여 range를 지정
                        let startIndex = resultString.index(resultIndex!,offsetBy:4)
                        let endIndex = resultString.index(startIndex,offsetBy:23)
                        let range = startIndex ..< endIndex
                        let result = resultString[range]
                        
                        //결과값을 포함한 문자열을 나누어 Array에 저장
                        let resultArray = result.components(separatedBy: ", ")
                        //Array에 담긴 결과값들(문자열)을 Float으로 변환
                        let result1 = resultArray[0]
                        let num1 = (result1 as NSString).floatValue
                        let result2 = resultArray[1]
                        let num2 = (result2 as NSString).floatValue
                        let result3 = resultArray[2]
                        let num3 = (result3 as NSString).floatValue
                        let result4 = resultArray[3]
                        let num4 = (result4 as NSString).floatValue
                        let result5 = resultArray[4]
                        let num5 = (result5 as NSString).floatValue
                        
                        let results = [num1,num2,num3,num4,num5]
                        print(results)
                        //결과값들을 UserDefault에 저장
                        UserDefaults.standard.set(results,forKey: "results")
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        completion()
    }
    @IBAction func submitBtnPressed(_ sender: Any) {
        self.getResult {
            print("mission complete!")
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
    }
    //웰컴뷰에서 넘어온 기기정보 받는 설정
    var iphonetype = String()


}
