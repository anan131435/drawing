//
//  RootViewController.swift
//  PeKi
//
//  Created by 韩志峰 on 2023/4/20.
//

import UIKit
import Photos
class RootViewController: UIViewController {
    private lazy var canvasView: CanvasView = {
        let canvasView = CanvasView.init(frame: UIScreen.main.bounds)
        return canvasView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PeKi"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(canvasView)
        setupChildViews()
    }
    
    func setupChildViews() {
        let delteBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        delteBtn.setBackgroundImage(UIImage.init(named: "delete"), for: .normal)
        delteBtn.setBackgroundImage(UIImage.init(named: "delete"), for: .highlighted)
        delteBtn.addTarget(self, action: #selector(deleteItemClick), for: .touchUpInside)
        
//        let backDoneBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        backDoneBtn.setBackgroundImage(UIImage.init(named: "backdone"), for: .normal)
//        backDoneBtn.setBackgroundImage(UIImage.init(named: "backdone"), for: .highlighted)
//        backDoneBtn.addTarget(self, action: #selector(undoItemClick), for: .touchUpInside)
        let deleteItem = UIBarButtonItem(customView: delteBtn)
//        let backdoneItem = UIBarButtonItem(customView: backDoneBtn)
        self.navigationItem.rightBarButtonItems = [deleteItem]
        
        let shareButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        shareButton.setBackgroundImage(UIImage.init(named: "share"), for: .normal)
        shareButton.setBackgroundImage(UIImage.init(named: "share"), for: .highlighted)
        shareButton.addTarget(self, action: #selector(shareImageClick), for: .touchUpInside)
        let shareItem = UIBarButtonItem(customView: shareButton)
        
        self.navigationItem.leftBarButtonItem = shareItem
    }
    
    @objc func deleteItemClick() {
        canvasView.deleteDrawing()
    }
    
    @objc func undoItemClick() {
        print("undoItemClick")
        canvasView.restoreDrawing()
    }
    
    @objc func shareImageClick() {

        
    
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .authorized {
                    if let image = canvasView.fetchImage() {
                        self.saveImage(image: image)
                    }
                    
                } else {
                    self.alertUser(message: "请在iPhone的“设置--隐私--相册”选项中，允许此App访问你的相册。")
                }
            }
        

        
    }
    
    private func saveImage(image: UIImage) {
         let imageManager = TZImageManager()
         imageManager.savePhoto(with: image) { asset, error in
             if asset != nil {
                 SVProgressHUD.showSuccess(withStatus: "保存成功")
             }
             
             if error != nil {
                 SVProgressHUD.showError(withStatus: "保存失败")
             }
         }
     }

    
    /// 弹窗提示
    private func alertUser(message: String) {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "设置", style: UIAlertAction.Style.default, handler: { (_) in
             DispatchQueue.main.async {
                 self.openApplicationSetting()
             }
         }))
         alert.addAction(UIAlertAction(title: "知道了", style: UIAlertAction.Style.cancel, handler: nil))
         present(alert, animated: true, completion: nil)
    }
     
    /// 打开设置
    func openApplicationSetting() {
         if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
             UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
         }
    }


}
