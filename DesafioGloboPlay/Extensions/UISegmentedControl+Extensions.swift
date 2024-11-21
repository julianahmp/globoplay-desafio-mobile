//
//  UISegmentedControl+Extensions.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 18/11/24.
//

import Foundation
import UIKit

extension UISegmentedControl {
  
    func removeBorder() {
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        /// Removes divider of UISegmentedControl
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        /// Sets text attributes
        self.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
    }
    
    func addUnderlineForSelectedSegment() {
        DispatchQueue.main.async() {
            self.removeUnderline()
            
            let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
            let underlineHeight: CGFloat = 10.0
            let underlineXPosition = CGFloat(self.selectedSegmentIndex * Int(underlineWidth))
            let underLineYPosition = self.bounds.size.height - 4.0
            
            let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
            
            let underline = UIView(frame: underlineFrame)
            underline.backgroundColor = UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            }
            underline.tag = 1
            self.addSubview(underline)
            self.bringSubviewToFront(underline)
        }
    }
    
    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
    
    func removeUnderline() {
        guard let underline = self.viewWithTag(1) else {return}
        underline.removeFromSuperview()
    }
    
    func setupSegment() {
        DispatchQueue.main.async() {
            self.removeBorder()
            self.addUnderlineForSelectedSegment()
        }
    }
}
