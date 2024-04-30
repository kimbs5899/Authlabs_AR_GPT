//
//  LoadingIndicatorView.swift
//  Authlabs_App
//
//  Created by Matthew on 4/29/24.
//

import Foundation
import Lottie

enum LoadingIndicatorView {
  static func showLoading(in view: UIView) {
    let animationView: LottieAnimationView
    
    guard
      let existedView = view.subviews.first(where: { $0 is LottieAnimationView } ) as? LottieAnimationView
    else {
      animationView = .init(name: "Animation - 20240429")
      animationView.frame = view.bounds
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop
      animationView.animationSpeed = 0.5
      animationView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
      view.addSubview(animationView)
      animationView.play()
      return
    }
    animationView = existedView
    animationView.play()
  }
  
  static func hideLoading(in view: UIView) {
    DispatchQueue.main.async {
      view.subviews.filter({ $0 is LottieAnimationView }).forEach { $0.removeFromSuperview() }
    }
  }
}
