//
//  ColorPickerView.swift
//  Color Picker
//
//  Created by Sylvan .D. Ash on 2/4/16.
//  Copyright © 2016 Daitensai. All rights reserved.
//

import Foundation
import UIKit

internal protocol ColorPickerDelegate: NSObjectProtocol {
    func colorPickerTouched(sender: ColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState)
}

@IBDesignable
class ColorPicker: UIView {
    
    weak internal var delegate: ColorPickerDelegate?
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        
        let touchGesture = UILongPressGestureRecognizer(target: self, action: "touchedColor:")
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.max
        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for var y = CGFloat(0.0); y < rect.height; y += self.elementSize {
            let saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : CGFloat(1.0)
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for var x = CGFloat(0.0); x < rect.width; x += self.elementSize {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                
                CGContextSetFillColorWithColor(context, color.CGColor)
                CGContextFillRect(context, CGRect(x: x, y: y, width: self.elementSize, height: self.elementSize))
            }
        }
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)), y:elementSize * CGFloat(Int(point.y / elementSize)))
        
        let saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height : CGFloat(1.0)
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self)
        let color = getColorAtPoint(point)
        
        self.delegate?.colorPickerTouched(self, color: color, point: point, state: gestureRecognizer.state)
    }
}








