//
//  CoreImage.swift
//  Core
//
//  Created by Mananchai Rojamornkul on 5/6/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

public extension UIImage {
    static func getImageNamed(_ name: String, in bundle: Bundle) -> UIImage {
        if let image = UIImage(named: name, in: bundle, compatibleWith: .init()) {
            return image
        } else {
            #if DEBUG
                fatalError("Could not initialize \(UIImage.self) named \(name).")
            #else
                return UIImage(named: "placeholder", in: Bundle.this, compatibleWith: .init())!
            #endif
        }
    }
    
    func imageWith(newSize: CGSize) -> UIImage {
  
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
    
    func coreConvertToGrayScale() -> UIImage {
        guard let currentCGImage = self.cgImage else { fatalError() }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { fatalError() }
        
        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        } else {
            return self
        }
    }
}
