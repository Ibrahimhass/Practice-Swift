//
//  Swift_PracticeApp.swift
//  Swift-Practice
//
//  Created by Ibrahim Hassan on 08/05/22.
//

import SwiftUI

@main
struct Swift_PracticeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: CodeRunner())
                .frame(minWidth: 600, minHeight: 600, alignment: .topLeading)
        }
    }
}
