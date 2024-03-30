//
//  RootViewController.swift
//  PeKi
//
//  Created by 韩志峰 on 2023/4/20.
//

import UIKit

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
        
        let backDoneBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        backDoneBtn.setBackgroundImage(UIImage.init(named: "backdone"), for: .normal)
        backDoneBtn.setBackgroundImage(UIImage.init(named: "backdone"), for: .highlighted)
        backDoneBtn.addTarget(self, action: #selector(undoItemClick), for: .touchUpInside)
        let deleteItem = UIBarButtonItem(customView: delteBtn)
        let backdoneItem = UIBarButtonItem(customView: backDoneBtn)
        self.navigationItem.rightBarButtonItems = [backdoneItem,UIBarButtonItem.init(systemItem: .fixedSpace) , deleteItem]
        
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
        canvasView.restoreDrawing()
    }
    
    @objc func shareImageClick() {
        if let resultImage = canvasView.fetchImage() {
            let activityVC = UIActivityViewController(activityItems: [resultImage], applicationActivities: [])
            activityVC.excludedActivityTypes = [.mail, .addToReadingList, .assignToContact]
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x:  88, y:0 , width: 88, height: 88)
                activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
                }
            self.present(activityVC, animated: true, completion: nil)
            
        }
    }

}
