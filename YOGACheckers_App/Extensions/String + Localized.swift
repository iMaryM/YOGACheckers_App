//
//  String + Localized.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 9.10.21.
//

import UIKit

extension String {
    func localized(by language: String) -> String {
        guard let localizationPath = Bundle.main.path(forResource: language, ofType: "lproj"),
        let localizationBundle = Bundle(path: localizationPath) else { return self}
        return NSLocalizedString(self, bundle: localizationBundle, value: self, comment: self)
    }
}
