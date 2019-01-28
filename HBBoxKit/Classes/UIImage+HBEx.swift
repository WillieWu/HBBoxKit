//
//  UIImage+HBEx.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/7.
//

import UIKit

public extension UIImage {
    
    /// 根据RGB生成UIImage
    ///
    /// - Parameter color: Color
    /// - Returns: UIImage
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
    
    /// 压缩图片
    public func hb_compressImage(toWidth width: CGFloat = 375) -> Data? {
        let newImage = self.hb_scaleDown(toWidth: width)
        guard newImage != nil else { return nil }
        return UIImageJPEGRepresentation(newImage!, 0.75)
    }
    
    /// 将image等比缩放
    ///
    /// - Parameter width: 缩放的宽度
    /// - Returns: 缩放后的图片
    public func hb_scaleDown(toWidth width: CGFloat = 375) -> UIImage? {
        let newSize = CGSize(width: width, height: self.size.height * width / self.size.width)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
}
