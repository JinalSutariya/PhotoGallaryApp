//
//  AppConst.swift
//  Unsplash
//
//  Created by CubezyTech on 07/12/23.
//

import CoreImage

struct AppConst {
   
    static let baseurl = "https://api.unsplash.com/"
    static let photoUrl = "photos"
    static let clinetid = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"
    static let topics = "topics"
    static let search = "search/photos"
}

enum imagePathType {
    case cameraRoll
    case appStorage
    case phoneStorage
}


class ColorFilterGenerator {
    
    private static let DELTA_INDEX: [Float] = [
        0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
        0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
        0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
        0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
        0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
        1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
        1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,
        2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
        4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
        7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,
        10.0
    ]
    
    static func adjustHue(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 180.0) / 180.0 * Float.pi
        if value == 0 {
            return
        }
        
        let cosVal = cos(value)
        let sinVal = sin(value)
        let lumR: Float = 0.213
        let lumG: Float = 0.715
        let lumB: Float = 0.072
        let mat: [Float] = [
            lumR + cosVal * (1 - lumR) + sinVal * (-lumR), lumG + cosVal * (-lumG) + sinVal * (-lumG), lumB + cosVal * (-lumB) + sinVal * (1 - lumB), 0, 0,
            lumR + cosVal * (-lumR) + sinVal * (0.143), lumG + cosVal * (1 - lumG) + sinVal * (0.140), lumB + cosVal * (-lumB) + sinVal * (-0.283), 0, 0,
            lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)), lumG + cosVal * (-lumG) + sinVal * (lumG), lumB + cosVal * (1 - lumB) + sinVal * (lumB), 0, 0,
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 1
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func adjustBrightness(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 100.0)
        if value == 0 {
            return
        }
        
        let mat: [Float] = [
            1, 0, 0, 0, value,
            0, 1, 0, 0, value,
            0, 0, 1, 0, value,
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 1
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func adjustContrast(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 100.0)
        if value == 0 {
            return
        }
        
        var x: Float
        if value < 0 {
            x = 127 + value / 100 * 127
        } else {
            x = value.truncatingRemainder(dividingBy: 1)
            if x == 0 {
                x = DELTA_INDEX[Int(value)] // this is how the IDE does it.
            } else {
                x = DELTA_INDEX[Int(value)] * (1 - x) + DELTA_INDEX[Int(value) + 1] * x // use linear interpolation for more granularity.
            }
            x = x * 127 + 127
        }
        
        let mat: [Float] = [
            x / 127, 0, 0, 0, 0.5 * (127 - x),
            0, x / 127, 0, 0, 0.5 * (127 - x),
            0, 0, x / 127, 0, 0.5 * (127 - x),
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 1
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func adjustSaturation(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 100.0)
        if value == 0 {
            return
        }
        
        let x = 1 + ((value > 0) ? 3 * value / 100 : value / 100)
        let lumR: Float = 0.3086
        let lumG: Float = 0.6094
        let lumB: Float = 0.0820
        let mat: [Float] = [
            lumR * (1 - x) + x, lumG * (1 - x), lumB * (1 - x), 0, 0,
            lumR * (1 - x), lumG * (1 - x) + x, lumB * (1 - x), 0, 0,
            lumR * (1 - x), lumG * (1 - x), lumB * (1 - x) + x, 0, 0,
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 1
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func adjustBinary(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 100.0)
        if value == 0 {
            return
        }
        
        let mat: [Float] = [
            0.5, 0.5, 0.5, 0, value,
            0.5, 0.5, 0.5, 0, value,
            0.5, 0.5, 0.5, 0, value,
            0, 0, 0, 1, 0
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func adjustBlackWhite(_ cm: inout [Float], _ value: Float) {
        var value = cleanValue(value, 100.0)
        if value == 0 {
            return
        }
        
        let mat: [Float] = [
            0, 1, 0, 0, value,
            0, 0, 1, 0, value,
            1, 0, 0, 0, value,
            0, 0, 0, 1, 0
        ]
        multiplyMatrix(&cm, mat)
    }
    
    static func cleanValue(_ p_val: Float, _ p_limit: Float) -> Float {
        return min(p_limit, max(-p_limit, p_val))
    }
    
    static func multiplyMatrix(_ cm: inout [Float], _ mat: [Float]) {
        var result = [Float](repeating: 0, count: cm.count)
        for i in 0..<5 {
            for j in 0..<5 {
                var sum: Float = 0
                for k in 0..<5 {
                    sum += mat[i * 5 + k] * cm[k * 5 + j]
                }
                result[i * 5 + j] = sum
            }
        }
        cm = result
    }
    
    static func adjustColor(brightness: Int, contrast: Int, saturation: Int, hue: Int, binary: Int, blackwhite: Int) -> UIColorFilter {
        var cm = [Float](repeating: 0, count: 25)
        adjustHue(&cm, Float(hue))
        adjustContrast(&cm, Float(contrast))
        adjustBrightness(&cm, Float(brightness))
        adjustSaturation(&cm, Float(saturation))
        adjustBinary(&cm, Float(binary))
        adjustBlackWhite(&cm, Float(blackwhite))
        
        return UIColorFilter(colorMatrix: cm)
    }
}

class UIColorFilter: CIFilter {
    private var colorMatrix: [Float]
    
    init(colorMatrix: [Float]) {
        self.colorMatrix = colorMatrix
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var outputImage: CIImage? {
        let filter = CIFilter(name: "CIColorMatrix")
        filter?.setDefaults()
        filter?.setValue(CIVector(x: CGFloat(colorMatrix[0]), y: CGFloat(colorMatrix[1]), z: CGFloat(colorMatrix[2]), w: CGFloat(colorMatrix[3])), forKey: "inputRVector")
        filter?.setValue(CIVector(x: CGFloat(colorMatrix[5]), y: CGFloat(colorMatrix[6]), z: CGFloat(colorMatrix[7]), w: CGFloat(colorMatrix[8])), forKey: "inputGVector")
        filter?.setValue(CIVector(x: CGFloat(colorMatrix[10]), y: CGFloat(colorMatrix[11]), z: CGFloat(colorMatrix[12]), w: CGFloat(colorMatrix[13])), forKey: "inputBVector")
        filter?.setValue(CIVector(x: CGFloat(colorMatrix[15]), y: CGFloat(colorMatrix[16]), z: CGFloat(colorMatrix[17]), w: CGFloat(colorMatrix[18])), forKey: "inputAVector")
        filter?.setValue(CIVector(x: CGFloat(colorMatrix[20]), y: CGFloat(colorMatrix[21]), z: CGFloat(colorMatrix[22]), w: CGFloat(colorMatrix[23])), forKey: "inputBiasVector")
        
        return filter?.outputImage
    }
}
