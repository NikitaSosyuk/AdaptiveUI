//
//  AUITableView.swift
//  AdaptiveUI
//
//  Created by n.sosyuk on 14.12.2022.
//

import Foundation
import UIKit

public final class AUITableView: AUIView {

    public struct Data: Serializable {
        public enum Kind {
            case text(String)
            case image(String)
        }

        @Convertible
        public var identifierToData: [String: Kind]

        @Convertible
        public var cellType: String

        @Convertible
        public var selectActionId: String?

        public init() {}
    }

    @Convertible
    public var cellsTypes: [String: AUITableViewCell]

    @Convertible
    public var data: [Data]

    @Convertible(default: true)
    public var isSeparatorHidden: Bool
}

public class AUITableViewCell: AUIView {

    @Convertible
    public var layout: [AUIConstraint]

    public required init() {}
}