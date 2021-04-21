//
//  LKDemoController.swift
//  NativeH5MixDemo
//
//  Created by CPHKEP on 2021/4/21.
//

import UIKit

class LKDemoController: LKAppServerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "当前是 WKWebview"
    }
    
    //MARK:  super
    
    override func didAcceptCommand(_ name: String, arguments: String) {
        super.didAcceptCommand(name, arguments: arguments)
        
        // 处理 Command
        let name = name.toDictionary!
        let arguments = arguments.toDictionary
        
        if (name["cmd_name"] as! String == "Log") {
            // 打印
            print("\n🐒 H5 to App 🐒\nname = \(name)\narguments = \(arguments)")
        }
        else if (name["cmd_name"] as! String == "Alert") {
            // 弹窗
            alert(arguments!)
        }
        else if (name["cmd_name"] as! String == "JumpPage") {
            // 跳转页面
            jumpPage(arguments!)
        }
        else if (name["cmd_name"] as! String == "TakePicture") {
            // 拍照
            takePicture()
        }
    }
    
    //MARK: Command
    
    func alert(_ arguments: Dictionary<String, Any>) {

        let alert = UIAlertController(title: "\(arguments["title"])", message: "\(arguments["message"]))", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {
            ACTION in
            print("你点击了OK")
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func jumpPage(_ arguments: Dictionary<String, Any>) {
        
        let pageName = arguments["pageName"]
        if (pageName as! String == "list") {
            
            let listVC = UIViewController.init()
            listVC.title = "list"
            listVC.view.backgroundColor = .white
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    func takePicture() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true) {}
    }
    
    
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        //当选择的类型是图片
        if type == "public.image" {
            
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? UIImage.init()
            
            // 图片 base64 处理
            let imageBase64String = image.base64String
            
            // 成功回调
            let imageData = ["image": imageBase64String]
            let response = ["status": "1",
                            "data": imageData] as [String : Any]
            
            callJS(response.JSONString)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        // 失败回调
        let response = ["status": "0",
                        "data": "",
                        "message": "取消拍照"] as [String : Any]
        callJS(response.JSONString)
    }
}



