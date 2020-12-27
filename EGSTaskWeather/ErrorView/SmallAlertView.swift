//
//  ErrorAlertView.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import RxCocoa


//MARK: - SmallAlertView

final class SmallAlertView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    @IBOutlet weak var contentBoxView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    var action: ((SmallAlertView) -> ())?
    
    init(in controller: UIViewController, title: String, message: String, actionTitle: String) {
        super.init(frame: .zero)
        commonInit(controller: controller, title: title, message: message, actionTitle: actionTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func removeFromSuperview() {
        removeContent { (_) in
            super.removeFromSuperview()
        }
    }
    
    private func commonInit(controller: UIViewController, title: String, message: String, actionTitle: String) {
        let commonView = (Bundle.main.loadNibNamed("SmallAlertView", owner: self, options: nil) as! [UIView]).first!
        guard let parentView = controller.view else { return }
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.actionButton.setTitle(actionTitle, for: .normal)
        addSubview(commonView)
        commonView.translatesAutoresizingMaskIntoConstraints = false
        commonView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        commonView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        commonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commonView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false 
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        
        parentView.layoutIfNeeded()
        showContent()
    }
    
    private func showContent() {
        backgroundShadowView.alpha = 0
        contentBoxView.alpha = 0
        contentBoxView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2) {
            self.backgroundShadowView.alpha = 1
            self.contentBoxView.alpha = 1
            self.contentBoxView.transform = .identity
        }
    }
    
    private func removeContent(_ completion: @escaping (Bool)->()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundShadowView.alpha = 0
            self.contentBoxView.alpha = 0
            self.contentBoxView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: completion)
    }

    @IBAction func didTappButton(_ sender: UIButton) {
        action?(self)
    }
    
    @discardableResult
    static func showError(inViewController: UIViewController, title: String, message: String, actionTitle: String, action: ((SmallAlertView) -> ())?) -> SmallAlertView {
        
        let errorView = SmallAlertView(in: inViewController, title: title, message: message, actionTitle: actionTitle)
        errorView.action = action
        return errorView
    }
}

