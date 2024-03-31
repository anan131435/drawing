//
//  CanvasView.swift
//  PeKi
//
//  Created by 韩志峰 on 2023/4/20.
//

import UIKit
import PencilKit

class CanvasView: UIView {
    
    var canvasView = PKCanvasView()
    var onSaved: (() -> Void)? = nil
    var toolPicker = PKToolPicker()
    var rendition: Rendition?
    var coordinator: Coordinator?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let coordinator = Coordinator(canvasView: canvasView) { [weak self] in
            guard let self = self else {return}
            self.saveDrawing()
        }
        self.coordinator = coordinator
        canvasView.tool = PKInkingTool(.pen,color: UIColor.gray,width: 10)
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = coordinator
        canvasView.frame = UIScreen.main.bounds
        self.addSubview(canvasView)
        showToolPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showToolPicker() {
      toolPicker.setVisible(true, forFirstResponder: canvasView)
      toolPicker.addObserver(canvasView)
      canvasView.becomeFirstResponder()
    }
    
    // **************************Public Method****************************
    
    func saveDrawing() {
        print("saveDrawing")
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        let rendition = Rendition(title: "Peki Product", drawing: canvasView.drawing, image: image)
        self.rendition = rendition
    }
    
    func deleteDrawing() {
        canvasView.drawing = PKDrawing()
    }
    
    func restoreDrawing() {
        if let rendition = rendition {
            canvasView.drawing = rendition.drawing
        } else {
            print("restoreDrawing failed");
        }
    }
    
    func fetchImage() -> UIImage? {
        return rendition?.image
    }
    
}

class Coordinator: NSObject {
  var canvasView: PKCanvasView
  let onSaved: (() -> Void)?
    init(canvasView: PKCanvasView, onSaved: (() -> Void)?) {
    self.canvasView = canvasView
    self.onSaved = onSaved
  }
}

extension Coordinator: PKCanvasViewDelegate {
  func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
      
    if !canvasView.drawing.bounds.isEmpty {
        
        if self.onSaved != nil {
            self.onSaved!()
        }
    }
  }
}
