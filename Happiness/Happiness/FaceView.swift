//
//  FaceView.swift
//  Happiness
//
//  Created by Binea Xu on 6/7/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

protocol FaceViewDataSource : class{
    func faceViewForDataSource(sender:FaceView) ->Double?
}

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var lineWidth : CGFloat = 3{didSet{setNeedsDisplay()}}
    @IBInspectable
    var color : UIColor = UIColor.blueColor(){didSet{setNeedsDisplay()}}
    @IBInspectable
    var scale : CGFloat = 0.90{didSet{setNeedsDisplay()}}
    
    var faceCenter : CGPoint{
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius : CGFloat{
        return min(bounds.width, bounds.height) / 2 * 0.90
    }
    
    var smileless : Double = 0.75{didSet{setNeedsDisplay()}}
    
    private struct Scaleing{
        static let FaceRadiusToEyeRadiusRatio : CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio : CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio : CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio : CGFloat = 1
        static let FaceRadiusToMouthHeightRatio : CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio : CGFloat = 3
    }
    
    enum Eye{
        case LEFT,RIGHT
    }
    
    weak var dataSource : FaceViewDataSource?
    
    private func bezierPathForEye(whichEye:Eye) ->UIBezierPath{
        let eyeRadius = faceRadius / Scaleing.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaleing.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaleing.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
        case .LEFT:
            eyeCenter.x -= eyeHorizontalSeparation/2
        case .RIGHT:
            eyeCenter.x += eyeHorizontalSeparation/2
            
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile : Double)->UIBezierPath{
        let mouthWidth = faceRadius / Scaleing.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaleing.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaleing.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x:faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x:start.x + mouthWidth, y: start.y)
        
        let cp1 = CGPoint(x:start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x:end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        path.stroke()
        
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        bezierPathForEye(Eye.LEFT)
        bezierPathForEye(Eye.RIGHT)
        smileless = dataSource?.faceViewForDataSource(self) ?? 0.0
        bezierPathForSmile(smileless)
        
    }

}
