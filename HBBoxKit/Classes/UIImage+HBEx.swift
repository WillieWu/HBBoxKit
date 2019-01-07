//
//  UIImage+HBEx.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/7.
//

import Foundation

public extension UIImage {
    public class func hb_image(withColor color: Color) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
