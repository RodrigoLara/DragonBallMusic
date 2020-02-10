//
//  Extension.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 08/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

extension FileManager {
    class func directoryUrl() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    class func saveFiles() {
        let paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
        
        if allRecordedFiles()?.count != paths.count {
            if let documentsUrl = FileManager.directoryUrl() {
                for path in paths {
                    do {
                        let filePath = documentsUrl.appendingPathComponent(path.components(separatedBy: "/").last!).path
                        
                        if !FileManager.default.fileExists(atPath: filePath) {
                            try FileManager.default.copyItem(atPath: path, toPath: filePath)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    class func allRecordedFiles() -> [URL]? {
       if let documentsUrl = FileManager.directoryUrl() {
          do {
              let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
              return directoryContents.filter{ $0.pathExtension == "mp3" }
          } catch {
              return nil
          }
       }
       return nil
    }
}

extension CMTime {
    var asDouble: Double {
        get {
            return Double(self.value) / Double(self.timescale)
        }
    }
    var asFloat: Float {
        get {
            return Float(self.value) / Float(self.timescale)
        }
    }
}

extension CMTime: CustomStringConvertible {
    public var description: String {
        get {
            let seconds = Int(round(self.asDouble))
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }
    }
}

extension UIViewController {
    func setupCustomNavigationBackButton() {
        var backBtn = UIImage(named: "Back")
        backBtn = backBtn?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = backBtn;
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBtn;
    }
    
    func showAlert(title: String, message: String) {
        let alertAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory = paths[0]
        let path = documentsDirectory.appending("/profile.jpg")
        let data = image.jpegData(compressionQuality: 0)
        try! data?.write(to: URL(fileURLWithPath: path))
    }
    
    func loadImage() -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory = paths[0]
        let path = documentsDirectory.appending("/profile.jpg")
        
        let image = UIImage(contentsOfFile: path)
        
        return image
    }
}

extension UserDefaults {
    class func saveFirstTimeApp(firstTime: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(firstTime, forKey: "FirstTimeApp")
        userDefaults.synchronize()
    }
    
    class func isFirstTimeApp() -> Bool {
        let userDefaults = UserDefaults.standard
        
        guard let firstTime = userDefaults.object(forKey: "FirstTimeApp") as? Bool else {
            return true
        }
        
        return firstTime
    }
}

extension UITextField {
    func validatedText() -> String? {
        guard let value = self.text else { return nil }
        
        if value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            return nil
        }
        
        return value
    }
}
