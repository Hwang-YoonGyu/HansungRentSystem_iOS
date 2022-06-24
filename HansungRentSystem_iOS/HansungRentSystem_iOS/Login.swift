//
//  ViewController.swift
//  HansungRentSystem_iOS
//
//  Created by 황윤규 on 2022/06/22.
//

import UIKit
import Foundation

class Login: UIViewController {

    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var idField: UITextField!
    
    
    @IBAction func joinBtn(_ sender: UIButton) {
        let storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mvc = storyBoard?.instantiateViewController(withIdentifier: "Join") as? Main {
            
            navigationController?.pushViewController(mvc, animated: true)

        }
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        
        let requset = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.2:8080/API/login?userId="+idField.text!+"&password="+pwdField.text!)! as URL)
        requset.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: requset as URLRequest) {
            data, response, error in
            if error != nil {
                print("error")
                return
            }
            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
            
                let resultString = String(describing: responseString)
                
                print(resultString)

                var dicData : Dictionary<String, Any> = [String : Any]()
                    do {
                        // 딕셔너리에 데이터 저장 실시
                        dicData = try JSONSerialization.jsonObject(with: Data(resultString.utf8), options: []) as! [String:Any]
                        DispatchQueue.main.sync {
                            let storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
                            if let mvc = storyBoard?.instantiateViewController(withIdentifier: "Main") as? Main {
                                mvc.userName = dicData["userName"]! as! String
                                mvc.userId = dicData["id"]! as! String
                                self.navigationController?.pushViewController(mvc, animated: true)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async{
                            print(error.localizedDescription)
                            let alert = UIAlertController(title:"로그인 실패",message: "아이디와 비밀번호를 확인해주세요",preferredStyle: UIAlertController.Style.alert)
                            //확인 버튼 만들기
                            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert,animated: true,completion: nil)
                        }
                    }
            }
        }
        task.resume()
        print("@@@@@@@@@@@@@@@@@")
        

    }
    func gotoMain() {
        let storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mvc = storyBoard?.instantiateViewController(withIdentifier: "Main") as? Main {                            self.navigationController?.pushViewController(mvc, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
