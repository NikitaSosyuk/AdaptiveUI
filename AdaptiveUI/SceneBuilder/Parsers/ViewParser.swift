//
//  ViewParser.swift
//  AdaptiveUI
//
//  Created by n.sosyuk on 06.11.2022.
//

import UIKit
import SafariServices

enum BaseViewConfigurator {
    static func configure(
        view: UIView,
        configuration: AUIView,
        viewController: AUIViewController,
        skipActions: Bool = false
    ) {
        view.alpha = configuration.alpha
        view.isHidden = configuration.isHidden
        view.layer.cornerRadius = configuration.cornerRadius
        view.clipsToBounds = true
        view.backgroundColor = UIColor(from: configuration.backgroundColor)
        view.accessibilityIdentifier = configuration.accessibilityIdentifier

        if viewController.viewHierarchy[configuration.identifier] == nil {
            viewController.viewHierarchy[configuration.identifier] = .view(view)
        }

        guard let action = configuration.actionHandler, !skipActions else { return }
        let actionWrapper = AUIActionWrapper { [weak viewController] in
            switch action {
            case .custom(let id):
                viewController?.actions[id]?()
            case .standard(let type):
                DispatchQueue.main.async {
                    Self.defaultAction(type: type, viewController: viewController)
                }
            }
        }
        viewController.actionWrappers.append(actionWrapper)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: actionWrapper,
            action: #selector(actionWrapper.action)
        )
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private static func defaultAction(type: AUIAction.StandardActionType, viewController: AUIViewController?) {
        switch type {
        case .alert(let title, let message, let buttonText):
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: nil))
            viewController?.present(alert, animated: true)

        case .openWebURL(let url):
            guard let url = URL(string: url) else { return }
            let sfViewController = SFSafariViewController(url: url)
            if let navigationController = viewController?.navigationController {
                navigationController.pushViewController(sfViewController, animated: true)
            } else {
                viewController?.present(sfViewController, animated: true)
            }

        case .openScreen(let url):
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        }
    }
}
