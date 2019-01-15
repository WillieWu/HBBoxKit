//
//  String+HBEx.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/15.
//

import UIKit

public extension NSString {
    
    /// 设置最大高度，计算宽度
    ///
    /// - Parameters:
    ///   - maxHeight: 最大高度
    ///   - font: 默认 17
    /// - Returns: 宽度
    public func hb_sizeforWidth(_ maxHeight: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        return self.hb_size(withMaxSize: CGSize.init(width: 0, height: maxHeight), font: font).width
    }
    
    /// 设置最大宽度，计算高度
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    ///   - font: 默认 17
    /// - Returns: 高度
    public func hb_sizeforHeight(_ maxWidth: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        return self.hb_size(withMaxSize: CGSize.init(width: maxWidth, height: 0), font: font).height
    }
    
    
    /// 计算文字Size
    ///
    /// - Parameters:
    ///   - maxSize: 设置最大Size
    ///   - font: 字体
    /// - Returns: 文字Size
    public func hb_size(withMaxSize maxSize: CGSize, font: UIFont) -> CGSize {
        let textBounds = self.boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
        return textBounds.size;
    }
    
}

public extension NSAttributedString {
    
    /// 设置最大高度，计算宽度
    ///
    /// - Parameters:
    ///   - maxHeight: 最大高度
    /// - Returns: 宽度
    public func hb_sizeforWidth(_ maxHeight: CGFloat) -> CGFloat {
        return self.hb_attributedSize(withMaxSize: CGSize.init(width: 0, height: maxHeight)).width
    }
    
    /// 设置最大宽度，计算高度
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    /// - Returns: 高度
    public func hb_sizeforHeight(_ maxWidth: CGFloat) -> CGFloat {
        return self.hb_attributedSize(withMaxSize: CGSize.init(width: maxWidth, height: 0)).height
    }
    
    /// 计算文字Size
    ///
    /// - Parameters:
    ///   - maxSize: 设置最大Size
    /// - Returns: 文字Size
    public func hb_attributedSize(withMaxSize maxSize: CGSize) -> CGSize {
        let textBounds = self.boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        return textBounds.size;
    }
}
