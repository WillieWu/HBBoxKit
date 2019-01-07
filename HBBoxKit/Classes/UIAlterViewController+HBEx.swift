//
//  UIAlterViewController+Ex.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/2.
//

import Foundation

public extension UIAlertController {
    public class func hb_showAlertStyle(title: String?, content: String?, actionNames: [(String, UIAlertAction.Style)], actionHandle: @escaping ((_ actionName: String, _ actionIndex: Int) -> ())) {
        hb_show(title: title, content: content, style: .alert, actionNames: actionNames, actionHandle: actionHandle)
    }
    
    public class func hb_showAlertStyle(content: String?, actionNames: [(String, UIAlertAction.Style)], actionHandle: @escaping ((_ actionName: String, _ actionIndex: Int) -> ())) {
        hb_show(title: nil, content: content, style: .alert, actionNames: actionNames, actionHandle: actionHandle)
    }
    
    public class func hb_showSheetStyle(actions actionNames: [(String, UIAlertAction.Style)], actionHandle: @escaping ((_ actionName: String, _ actionIndex: Int) -> ())) {
        hb_show(title: nil, content: nil, style: .actionSheet, actionNames: actionNames, actionHandle: actionHandle)
    }
    
    public class func hb_showSheetStyleTitle(_ title: String, actionNames: [(String, UIAlertAction.Style)], actionHandle: @escaping ((_ actionName: String, _ actionIndex: Int) -> ())) {
        hb_show(title: title, content: nil, style: .actionSheet, actionNames: actionNames, actionHandle: actionHandle)
    }
    
    public class func hb_show(title: String?, content: String?, style: UIAlertController.Style, actionNames: [(String, UIAlertAction.Style)], actionHandle: @escaping ((_ actionName: String, _ actionIndex: Int) -> ())) {
        let settingAlter = UIAlertController(title: title, message: content, preferredStyle: style)
        for (index, (name, style)) in actionNames.enumerated() {
            let userlistAction = UIAlertAction(title: name, style: style) { (action) in
                actionHandle(name, index)
            }
            settingAlter.addAction(userlistAction)
        }
        HBTools.hb_currentViewController().present(settingAlter, animated: true, completion: nil)
    }
}
