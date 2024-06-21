import Foundation
import UIKit

class BlurView {
    
    static func getView(frame: CGRect, text: String = "No data available to preview") -> UIView {
        let view = UIView()
        view.frame = frame
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 40))
        label.font = UIFont(name: "Inter-Medium", size: 32)
      //  label.textColor = LIGHT_GREY
        label.textAlignment = .center
        label.center = view.center
        label.text = text
        view.addSubview(label)
        
        return view
    }
    
}
