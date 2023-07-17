//
//  KeyboardManager.swift
//  BeerChat
//
//  Created by Jun on 2023/07/16.
//

import UIKit
import Combine

class KeyboardManager: ObservableObject {
    @Published var isKeyboardActive = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeKeyboardNotifications()
    }

    private func observeKeyboardNotifications() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                self?.isKeyboardActive = true
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardActive = false
            }
            .store(in: &cancellables)
    }
}
