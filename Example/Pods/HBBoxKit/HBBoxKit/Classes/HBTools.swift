//
//  HBTools.swift
//  HBBoxKit
//
//  Created by 伍宏彬 on 2019/1/2.
//

import UIKit
import Photos
import UserNotifications
import CoreLocation

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func hb_once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    public func hb_async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    public func hb_after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}

public class HBTools: NSObject {
    private static var numFormat: NumberFormatter?
    /// view safeView
    public class func hb_safeViewInset() -> UIEdgeInsets {
        let rootVc = UIApplication.shared.keyWindow!
        if #available(iOS 11.0, *) {
            return rootVc.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    /// 格式化金额，样式 5,000.00
    public class func hb_formatMoney(withMoneyString money: String) -> String {
        if numFormat == nil {
            numFormat = NumberFormatter()
            numFormat!.numberStyle = .decimal;
            numFormat!.roundingMode = .halfUp;
            numFormat!.maximumFractionDigits = 2;
            numFormat!.minimumFractionDigits = 2;
        }
        return numFormat?.string(from: NSNumber(value: Double(money) ?? 0.00)) ?? "0.00"
    }
    
    /// 获取当前栈顶控制器
    public class func hb_currentViewController() -> UIViewController {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController!
        var currentVc: UIViewController? = nil
        if rootVc is UITabBarController {
            let tabbarVc = rootVc as! UITabBarController
            currentVc = tabbarVc.selectedViewController
        }
        if rootVc is UINavigationController {
            let navVc = rootVc as! UINavigationController
            currentVc = navVc.visibleViewController
        }
        if let presentVc = rootVc?.presentedViewController {
            currentVc = presentVc
        }
        return currentVc!
    }
}

//MARK: 系统信息相关
public extension HBTools {
    
    /// 打开URL
    ///
    /// - Parameter urlString: UIApplicationOpenSettingsURLString
    public class func hb_openSettingPage(urlString: String) {
        let settingURL = URL(string: urlString)
        guard let getURL = settingURL else {
            NSLog("URL 参数错误")
            return
        }
        if  UIApplication.shared.canOpenURL(getURL) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(getURL, options: [:],completionHandler: {(success) in})
            } else {
                UIApplication.shared.openURL(getURL)
            }
        }
    }
    
    /// 请求位置权限
    public class func hb_requestLocationPermission(_ localtionManager: CLLocationManager, isWhenUse: Bool, permissionStatus: ((_ success: Bool) -> ())?) {
        guard CLLocationManager.locationServicesEnabled() else {
            NSLog("定位不可用")
            permissionStatus?(false)
            return
        }
        let localStatus = CLLocationManager.authorizationStatus()
        if localStatus == .denied || localStatus == .restricted{
            permissionStatus?(false)
        } else if localStatus == .notDetermined {
            if isWhenUse {
                localtionManager.requestWhenInUseAuthorization()
            } else {
                localtionManager.requestAlwaysAuthorization()
            }
        } else {
            permissionStatus?(true)
        }
    }
    
    /// 请求麦克风权限
    public class func hb_requestMicroPermission(_ permissionStatus: ((_ success: Bool) -> ())?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.audio) { (granted) in
                permissionStatus?(granted)
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            permissionStatus?(false)
        } else {
            permissionStatus?(true)
        }
    }
    
    /// 请求摄像头权限
    public class func hb_requestCameraPermission(_ permissionStatus: ((_ success: Bool) -> ())?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                permissionStatus?(granted)
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            permissionStatus?(false)
        } else {
            permissionStatus?(true)
        }
    }
    
    /// 请求相册
    public class func hb_requestAlbumPermission(_ permissionStatus: ((_ success: Bool) -> ())?) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            permissionStatus?(false)
        } else if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (phStatus) in
                if phStatus == PHAuthorizationStatus.authorized {
                    permissionStatus?(true)
                } else {
                    permissionStatus?(false)
                }
            }
        } else {
            permissionStatus?(true)
        }
    }
    
    /// 请求本地推送和远程推送权限
    /// 只需要在失败的时候，做响应的提示或处理就行了
    /// - Parameter permissionStatus: 授权成功或失败（用户没有选择的时候，会自动请求授权）
    public class func requestPushPermission(_ permissionStatus: ((_ success: Bool) -> ())?) {
        //请求本地通知权限
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (notifaSetting) in
                if notifaSetting.authorizationStatus == .denied {
                    NSLog("本地通知授权拒绝")
                    permissionStatus?(false)
                } else if notifaSetting.authorizationStatus == .authorized {
                    NSLog("本地通知授权成功")
                    permissionStatus?(true)
                } else if notifaSetting.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                        (accepted, error) in
                        permissionStatus?(accepted)
                        if !accepted {
                            NSLog("用户不允许消息通知。")
                        }
                    }
                } else {
                    NSLog("本地通知授权-羊羊羊？？？")
                }
            }
        } else {
            if UIApplication.shared.currentUserNotificationSettings?.types == .none {
                let user = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(user)
            }
        }
        //向APNs请求token
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /// APP版本号和APP的build版本号
    public class func hb_APPFullVersion(_ connectString: String = "-") -> String {
        guard let version = hb_APPVersion() else { return "" }
        guard let build = hb_APPBuild() else { return "" }
        return version + connectString + build
    }
    
    /// 获取App的名称
    public class func hb_APPName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
    }
    
    /// 获取App的版本号
    public class func hb_APPVersion() -> String? {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    /// 获取App的build版本
    public class func hb_APPBuild() -> String? {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    }
    
    /// 获取App的BundleID
    public class func hb_APPBundleID() -> String? {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
    }
    
    /// 获取设备唯一标识符UUID
    public class func hb_PhoneIdentifierNumber() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// 获取设备所有者的名称
    public class func hb_PhoneUserName() -> String? {
        return UIDevice.current.name
    }
    
    /// 获取当前运行的系统
    public class func hb_PhoneDeviceName() -> String? {
        return UIDevice.current.systemName
    }
    
    /// 获取当前系统的版本
    public class func hb_PhoneVersion() -> String? {
        return UIDevice.current.systemVersion
    }
    
    /// 获取设备的型号  iPhone iPod touch
    public class func hb_PhoneModel() -> String? {
        return UIDevice.current.model
    }
    
    /// 获取本地化版本
    public class func hb_PhoneLocalModel() -> String? {
        return UIDevice.current.localizedModel
    }
}

//MARK: Photos相关
public extension HBTools {
    
    /// 根据视频PHAsset, 导出视频到沙盒，获取视频沙盒url
    public class func help_requestVideoURL(FromAsset asset: PHAsset, complete: @escaping ((_ success: Bool, _ fileURL: URL?) -> ())) {
        guard asset.mediaType == .video else {
            NSLog("asset 类型错误: \(asset) 不是视频类型")
            return
        }
        let filePath = FileManager.default.hb_cachesURL().appendingPathComponent("HBToolsTempVideo.mp4")
        //存在就删除上一次保存的文件
        if FileManager.default.fileExists(atPath: filePath.path) {
            try? FileManager.default.removeItem(at: filePath)
        }
        let options = PHVideoRequestOptions()
        options.version = .current;
        options.deliveryMode = .highQualityFormat;
        PHImageManager.default().requestExportSession(forVideo: asset, options: options, exportPreset: AVAssetExportPresetMediumQuality) { (exportSession, info) in
            exportSession?.outputURL = filePath
            exportSession?.shouldOptimizeForNetworkUse = false
            exportSession?.outputFileType = .mp4
            exportSession?.exportAsynchronously(completionHandler: {
                DispatchQueue.main.async(execute: {
                    if exportSession?.status == .completed {
                        NSLog("导出成功: \(filePath.path)")
                        complete(true, filePath)
                    }else if exportSession?.status == .failed {
                        NSLog("导出失败: \(filePath.path)" + "||" + (exportSession?.error?.localizedDescription)!)
                        complete(false, nil)
                    }else if exportSession?.status == .exporting {
                        NSLog("导出中……")
                    }else if exportSession?.status == .cancelled {
                        NSLog("导出取消: \(filePath.path)")
                        complete(false, nil)
                    }
                })
            })
        }
    }
    
    /// 根据PHAsset 获取图片或者视频的第一帧
    ///
    /// - Parameters:
    ///   - photoAsset: 资源 PHAsset
    ///   - isOriginaImage: 是否请求原图，是：imageSize为PHImageManagerMaximumSize，否：返回imageSize参数相近大小
    ///   - imageSize: 请求图片的大小
    ///   - complete: 图片获取完成回调
    public class func help_requestImage(fromAsset photoAsset: PHAsset, isOriginaImage: Bool = false, imageSize: CGSize, complete: @escaping ((_ getImage: UIImage?)->())) {
        var requestOptions: PHImageRequestOptions?
        if !isOriginaImage {
            requestOptions = PHImageRequestOptions()
            requestOptions!.deliveryMode = .highQualityFormat
            requestOptions!.isSynchronous = true
            requestOptions!.version = .current
            requestOptions!.resizeMode = .fast

        }
        PHImageManager.default().requestImage(for: photoAsset, targetSize:isOriginaImage ? PHImageManagerMaximumSize : imageSize , contentMode: .aspectFit, options: requestOptions, resultHandler: { (image, imageDic) in
            DispatchQueue.main.async {
                complete(image)
            }
        })
    }
}
