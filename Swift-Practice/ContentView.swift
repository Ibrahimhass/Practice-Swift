//
//  ContentView.swift
//  Swift-Practice
//
//  Created by Ibrahim Hassan on 08/05/22.
//

import SwiftUI
import Sourceful

struct ContentView: View {
    @ObservedObject var viewModel: CodeRunner
    @State var swiftSourceCode: String = ""
    
    let outputView = OutputView(swiftOutput: "")
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Button("Run (⌘ + R)") {
                        self.viewModel.runCode(swiftSourceCode)
                    }
                    .keyboardShortcut("r")
                }
                .frame(height: 40, alignment: .leading)
                
                EditorView(inputString: $swiftSourceCode)
                
                let hasError = !viewModel.error.isEmpty
                let header = hasError ? "Error" : "Output"
                let consoleOutput = hasError ? viewModel.error : viewModel.output
                let noOutputOrError = viewModel.error.isEmpty && viewModel.output.isEmpty
                
                ZStack(alignment: .topLeading) {
                    VStack {
                        Text(header)
                            .fontWeight(.bold)
                            .frame(alignment: .topLeading)
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0))
                        
                        TextEditor(text: .constant(consoleOutput))
                            .font(.title3)
                    }
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(8)
                .foregroundColor(Color.white)
                .background(Color.init(nsColor: NSColor.init(hex: "#2D2D2D")))
                .isHidden(noOutputOrError, remove: noOutputOrError)
            }
        }
    }
}

struct OutputOrErrorView: View {
    var topTile: String
    @State var output: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text(topTile)
                    .fontWeight(.bold)
                    .frame(alignment: .topLeading)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0))
                
                TextEditor(text: .constant(output))
                    .font(.title3)
            }
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(8)
        .foregroundColor(Color.white)
        .background(Color.init(nsColor: NSColor.init(hex: "#2D2D2D")))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CodeRunner())
    }
}

struct EditorView: View {
    @Binding var inputString: String
            
    var body: some View {
        SourceCodeTextEditor(text: $inputString)
    }
}

struct OutputView: View {
    @State var swiftOutput = ""
    
    var body: some View {
        Text(swiftOutput)
            .background(Color.red)
    }
}

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
