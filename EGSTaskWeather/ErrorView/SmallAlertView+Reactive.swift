//
//  SmallAlertView+Reactive.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import RxCocoa


//MARK: - Reactive binder for SmallAlert.

extension Reactive where Base: UIViewController {
    var alert: Binder<SmallAlert> {
        return Binder(base) { (base, alert) in
            if let hasAlert = base.view.subviews.first(where: {$0 is SmallAlertView}) {
                hasAlert.removeFromSuperview()
            }
            let alertView = SmallAlertView.showError(inViewController: base, title: alert.title, message: alert.message, actionTitle: alert.actionTitle, action: alert.action)
            alert.retrieve = {
                DispatchQueue.main.async {
                    alertView.removeFromSuperview()
                }
            }
        }
    }
}
