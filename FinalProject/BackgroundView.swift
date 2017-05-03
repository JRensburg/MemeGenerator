//
//  BackgroundView.swift
//  FinalProject
//
//  Created by Jaco Van Rensburg on 5/2/17.
//  Copyright © 2017 Jaco van  Rensburg. All rights reserved.
//

import UIKit

//@IBDesignable
class BackgroundView: UIView {
    @IBInspectable var lightColor: UIColor = UIColor.cyan
    @IBInspectable var darkColor: UIColor = UIColor.magenta
    @IBInspectable var patternSize:CGFloat = 60
    var shadedCube = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(darkColor.cgColor)
        context!.fill(rect)
        let drawSize = CGSize(width: patternSize, height: 2*patternSize)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        //Draws the cubes
        darkColor.setFill()
        drawingContext!.fill(CGRect(x:0,y:0, width:drawSize.width, height:drawSize.height))
        shadedCube.move(to:CGPoint(x:drawSize.width/2,y:drawSize.height))
        shadedCube.addLine(to: CGPoint(x:0,y:drawSize.height*(5/6)))
        shadedCube.addLine(to: CGPoint(x:0,y:drawSize.height/2))
        shadedCube.addLine(to: CGPoint(x:drawSize.width/2,y:drawSize.height*(2/3)))
        shadedCube.move(to: CGPoint(x:drawSize.width/2,y:0))
        shadedCube.addLine(to: CGPoint(x:drawSize.width,y:drawSize.height*(1/6)))
        shadedCube.addLine(to: CGPoint(x:drawSize.width,y:drawSize.height/2))
        shadedCube.addLine(to: CGPoint(x:drawSize.width/2,y:drawSize.height/3))
        shadedCube.move(to: CGPoint(x:0,y:drawSize.height/2))
        shadedCube.addLine(to: CGPoint(x:drawSize.width/2,y:drawSize.height/3))
        shadedCube.addLine(to: CGPoint(x:drawSize.width,y:drawSize.height/2))
        shadedCube.addLine(to: CGPoint(x:drawSize.width/2,y:drawSize.height*(2/3)))
        lightColor.setFill()
        shadedCube.fill()
        //adds the lines
        let line = UIBezierPath()
        line.lineWidth = 2
        line.move(to: CGPoint(x:0,y:drawSize.height/2))
        line.addLine(to: CGPoint(x:drawSize.width/2,y:drawSize.height*(2/3)))
        line.move(to:CGPoint(x:drawSize.width/2,y:drawSize.height/3))
        line.addLine(to: CGPoint(x:drawSize.width,y:drawSize.height/2))
        darkColor.setStroke()
        line.stroke()
        let line2 = UIBezierPath()
        line2.lineWidth = 2
        line2.move(to: CGPoint(x:0,y:drawSize.height*(1/6)))
        line2.addLine(to: CGPoint(x:drawSize.width/2,y:0))
        line2.move(to:CGPoint(x:drawSize.width/2,y:drawSize.height))
        line2.addLine(to: CGPoint(x:drawSize.width,y:drawSize.height*(5/6)))
        lightColor.setStroke()
        line2.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIColor(patternImage: image!).setFill()
        context?.fill(rect)
   }

    
    
}
