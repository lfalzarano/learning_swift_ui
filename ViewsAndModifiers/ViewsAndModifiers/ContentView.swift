//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Logan Falzarano on 10/20/25.
//

import SwiftUI

//Here content is just a type. Similar to other languages where <T> is often used
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    //must use a view builder to be able to use a closure with multiple views
    //it will add the Hstack for us, otherwise we have to do it ourselves
    @ViewBuilder let content: (Int, Int) -> Content //defines a closure
    
    var body: some View {
        ForEach(0..<rows, id: \.self) { row in
            HStack{
                ForEach(0..<columns, id: \.self) { column in
                    content(row, column)
                }
            }
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}


extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct WaterMark: ViewModifier {
    var text: String //view modifiers can accept strings
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
        }
    }
}

extension View {
    func watermarked(withText text: String) -> some View {
        modifier(WaterMark(text: text))
    }
}

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .background(.blue)
            .clipShape(.capsule)
    }
}

struct ContentView: View {
    @State private var useWhiteText: Bool = false
    
    // Can create variables which are views
    var motto1: Text = Text("Swift is fun!")
    
    // Does not apply @ViewBuilder automatically like on body so cannot use multiples views by default
    var motto2: some View {
        Text("Swift is awesome!")
    }
    
    //Can use a Stack, a Group, or add ViewBuilder
    @ViewBuilder var motto3: some View {
        HStack { //or Group
            Text("Swift is awesome!")
            Text("It's also fast!")
        }
    }
    
    // cannot return just a View - Swift UI needs to know what kind of specific view
    // could type out the long Modified Content type
    // but it's easier to just say some View
    
    // if we create body with VStack, SwiftUI really creates a TupleView using ViewBuilder
    var body: some View {
        ScrollView {
            VStack {
                
                
                //modifier order matters
                Button("Created with ternary operator. Click me to change text color") {
                    print(type(of: self.body))
                    useWhiteText.toggle()
                }
                .foregroundStyle(useWhiteText ? .white : .black)
                .background(.red)
                .frame(width: 200, height: 200)
                .border(Color.red)
                // see above. only one button, less code, also more efficient
                
                // more code and creates two views insider
                if useWhiteText {
                    Button("Created with if/else. Click me to change text color") {
                        print(type(of: self.body))
                        useWhiteText.toggle()
                    }
                    .foregroundStyle(useWhiteText ? .white : .black)
                    .background(.red)
                    .frame(width: 200, height: 200)
                    .border(Color.red)
                } else {
                    Button("Created with if/else. Click me to change text color") {
                        print(type(of: self.body))
                        useWhiteText.toggle()
                    }
                    .foregroundStyle(useWhiteText ? .white : .black)
                    .background(.red)
                    .frame(width: 200, height: 200)
                    .border(Color.red)
                }
                
                Button("Hello World!") {
                    print(type(of: self.body))
                }
                //type is ModifiedContent<ModifiedContent<ModifiedContent<ModifiedContent<Button<Text>, _ForegroundStyleModifier<Color>>, _BackgroundStyleModifier<Color>>, _FrameLayout>, _OverlayModifier<_ShapeView<_StrokedShape<_Inset>, Color>>>
                //each modifier returns a new view
                .foregroundStyle(.black)
                .frame(width: 200, height: 200) // order swapped
                .background(.red)
                .border(Color.red)
                
                //environment modifiers
                VStack {
                    Text("Haters gonna hate")
                    Text("hate")
                    Text("hate").font(Font.largeTitle) //overrides the environment modifiers
                    Text("hate").blur(radius: 0) //can't unblur
                    Text("hate").blur(radius: 9) //can blur further
                }
                .font(Font.largeTitle.bold())
                .blur(radius: 2) //regular modifier not an environment modifier
                .border(Color.red)
                
                VStack {
                    motto1
                        .foregroundStyle(Color.red)
                    motto2
                    motto3
                }
                .border(Color.red)
                
                VStack(spacing: 10) {
                    CapsuleText(text: "First")
                    CapsuleText(text: "Second")
                        .foregroundStyle(Color.red) //cannot set this inside because the one inside CapsuleText takes precedence
                }
                
                Text("Modify me with a custom modifier (no extension)")
                    .modifier(Title())
                Text("Modify me if custom modifider that has an extension")
                    .titleStyle()
                
                Color.blue
                    .frame(width: 100, height: 100)
                    .watermarked(withText: "Watermarked text")
                
                //trailing closure which returns a view is used
                //could use <View> or <HStack> but swift can infer the type
                GridStack(rows: 4, columns: 4) { row, col in
                            HStack{
                                Text("R\(row) C\(col)")
                            }
                        }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
