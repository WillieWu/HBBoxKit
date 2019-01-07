//
//  FileManager+Ex.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/3.
//

import Foundation

public extension FileManager {
    
    /// 获取document目录
    public func hb_documentURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// 获取caches目录
    public func hb_cachesURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    /// 文件是否存在
    public func hb_hasFile(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /// 删除文件
    public func hb_deleteFile(_ filePath: String) {
        if FileManager.default.hb_hasFile(filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }else{
            NSLog("没有此文件-\(filePath)")
        }
    }
    
}
