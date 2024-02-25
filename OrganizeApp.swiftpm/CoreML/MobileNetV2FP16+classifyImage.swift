//
//  MobileNetV2FP16+classifyImage.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import CoreML
import UIKit

extension MobileNetV2FP16 {
    func classifyImage(_ image: UIImage) -> String? {
        guard let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return nil
        }
        
        let output = try? self.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.first?.key

            return result
        }
        return nil
    }
}
