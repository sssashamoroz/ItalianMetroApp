//
//  ContentView.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = MetroMapViewModel()
    
    @State private var scale: CGFloat = 0.2
    @State private var lastScaleValue: CGFloat = 1.0 // To accumulate scale changes

    
    @State private var offset: CGSize = CGSize(width: -150, height: -100)
    @State private var lastDragValue: CGSize = CGSize(width: -150, height: -100) // To accumulate drag changes
    
    @State private var pathFound: Bool = false
    
    @State private var showingOverlay = true
    
    //Search Stations
    @State private var searchText = ""

    @State private var isSearching = false
    @State private var currentSelection: SelectionType = .none

    enum SelectionType {
        case source, destination, none
    }
    
    
    var body: some View {
        
        
        ZStack{
            //Metro Map 🚇
            GeometryReader { geometry in
                ZStack {
                    
                    // Draw connections as lines
                    ForEach(viewModel.connections, id: \.self) { connection in
                        
                        Path { path in

                            let start = CGPoint(
                                x: connection.from.xCoordinate * geometry.size.width/5,
                                y: connection.from.yCoordinate * geometry.size.height/5
                            )
                            let end = CGPoint(
                                x: connection.to.xCoordinate * geometry.size.width/5,
                                y: connection.to.yCoordinate * geometry.size.height/5
                            )
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        .stroke(connection.to.accentColor, lineWidth: 5)
                        .stroke(Color.black.opacity(pathFound ? 0.8 : 0.0), lineWidth: 5.1)
                    }
                    
                    // Draw stations as circles
                    ForEach(viewModel.stations, id: \.id) { station in
                        Circle()
                            .fill(station.accentColor)
                            .fill((Color.black.opacity(pathFound ? 0.8 : 0.0)))
                            .frame(width: 20, height: 20)
                            .scaleEffect(viewModel.isStationSelected(station) ? 1.5 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.isStationSelected(station))
                            .overlay{
                                if station.titleShown {
                                    Text(station.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
            
                                        .multilineTextAlignment(
                                            station.titleOrientation == "Up" || station.titleOrientation == "Down" ? .center :
                                            station.titleOrientation == "Left" ? .trailing :
                                            station.titleOrientation == "Right" ? .leading : .center
                                        )
                                    
                                        .bold()
                                        .frame(width: 130, height: 70)
                                        .shadow(color: .black, radius: 1)
//                                        .textOutlineEffect(
//                                            station.name,
//                                            textColor: .black, // Adjust the text color as needed
//                                            outlineColor: .white, // Outline color
//                                            lineWidth: 1 // Adjust the outline width as needed
//                                        )
                                        .offset(
                                            x: station.titleOrientation == "Left" ? -60 : (station.titleOrientation == "Right" ? 60 : 0),
                                            y: station.titleOrientation == "Up" ? 30 : (station.titleOrientation == "Down" ? -30 : 0)
                                        )
                                        .opacity(pathFound ? 0.2 : 1)

                                }
                            }
                            .position(
                                x: station.xCoordinate * geometry.size.width/5,
                                y: station.yCoordinate * geometry.size.height/5
                            )
                            .onTapGesture{
                                withAnimation{
                                    pathFound = false
                                }
                                viewModel.toggleStationSelection(station)
                            }
 
                    }
                    
                    
                    //Draw Found Path Connections
                    ForEach(0..<max(0, viewModel.path.count-1), id: \.self) { index in
                        let startStation = viewModel.path[index]
                        let endStation = viewModel.path[index + 1]
                        Path { path in
                            let start = CGPoint(
                                x: startStation.xCoordinate * geometry.size.width / 5,
                                y: startStation.yCoordinate * geometry.size.height / 5
                            )
                            let end = CGPoint(
                                x: endStation.xCoordinate * geometry.size.width / 5,
                                y: endStation.yCoordinate * geometry.size.height / 5
                            )
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        .stroke(startStation.accentColor, lineWidth: 5)
                    }
                    
                    // Draw Found Path as circles
                    ForEach(viewModel.path, id: \.id) { station in
                        Circle()
                            .fill(station.accentColor)
                            .frame(width: 20, height: 20) // Customize the size of the circle
                            .overlay{
                                if station.titleShown {
                                    Text(station.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
            
                                        .multilineTextAlignment(
                                            station.titleOrientation == "Up" || station.titleOrientation == "Down" ? .center :
                                            station.titleOrientation == "Left" ? .trailing :
                                            station.titleOrientation == "Right" ? .leading : .center
                                        )
                                    
                                        .bold()
                                        .frame(width: 130, height: 70)
                                        .shadow(color: .black, radius: 1)
//                                        .textOutlineEffect(
//                                            station.name,
//                                            textColor: .black, // Adjust the text color as needed
//                                            outlineColor: .white, // Outline color
//                                            lineWidth: 1 // Adjust the outline width as needed
//                                        )
                                        .offset(
                                            x: station.titleOrientation == "Left" ? -60 : (station.titleOrientation == "Right" ? 60 : 0),
                                            y: station.titleOrientation == "Up" ? 30 : (station.titleOrientation == "Down" ? -30 : 0)
                                        )
                                        .opacity(pathFound ? 1 : 0)

                                }

                            }
                            .position(
                                x: station.xCoordinate * geometry.size.width/5,
                                y: station.yCoordinate * geometry.size.height/5
                            )
                            .allowsHitTesting(false)
                    }
                    


                }
                .scaleEffect(scale)
                .offset(offset)

            }
            .background(Color.black.opacity(0.9))
            .background(Color.gray.opacity(1))
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / self.lastScaleValue
                        self.scale *= delta
                        self.lastScaleValue = value
                    }
                    .onEnded { _ in
                        self.lastScaleValue = 1.0
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let dragValue = value.translation
                        self.offset = CGSize(width: self.lastDragValue.width + dragValue.width, height: self.lastDragValue.height + dragValue.height)
                        
                        withAnimation{
                            self.isSearching = false
                        }

                    }
                    .onEnded { value in
                        self.lastDragValue = self.offset
                    }
            )
            

            
            if showingOverlay {
                // This is a simplistic overlay; customize as needed.
                VStack {
                    Spacer()
                    
                    VStack {
                        
                        Capsule()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 60, height: 6)
                            .padding(.top, 10)
                            .onTapGesture{
                                withAnimation{
                                    isSearching.toggle()
                                }
                            }
                        
                        HStack{
                            
                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(currentSelection == .source ? 0.5 : 0), lineWidth: 4)
                                )
                                .padding(10)
                                .frame(height: 70)
                                .overlay{
                                    HStack{
                                        Circle()
                                            .fill(viewModel.selectedSource?.accentColor ?? .gray)
                                            .frame(width: 10, height: 10)
                                        
                                        if let selectedSource = viewModel.selectedSource {
                                            Text(selectedSource.name)
                                                .foregroundColor(.white)
                                                .bold()
                                        } else {
                                            Text("From")
                                                .foregroundColor(.white)
                                                .bold()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    self.currentSelection = .source
                                    self.isSearching = true
                                }
                                

                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(currentSelection == .destination ? 0.5 : 0), lineWidth: 4)
                                )
                                .padding(10)
                                .frame(height: 70)
                                .overlay{
                                    HStack{
                                        Circle()
                                            .fill(viewModel.selectedDestination?.accentColor ?? .gray)
                                            .frame(width: 10, height: 10)
                                        
                                        if let selectedSource = viewModel.selectedDestination {
                                            Text(selectedSource.name)
                                                .foregroundColor(.white)
                                                .bold()
                                        } else {
                                            Text("To")
                                                .foregroundColor(.white)
                                                .bold()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    self.currentSelection = .destination
                                    self.isSearching = true
                                }

                        }
                        .padding(.horizontal, 5)
                        
                        if isSearching {
                            TextField("", text: $searchText, prompt: Text("Search station...").foregroundColor(.white.opacity(0.5)))
                                .bold()
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Add padding around the text field
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2)) // Set background color
                                .cornerRadius(10) // Apply rounded corners
                                //.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)) // Add border
                                .foregroundColor(.white) // Text color
                                .padding()
                            
                            List(filteredStations(searchText)) { station in
                                
                                HStack{
                                    
                                    Circle()
                                        .fill(station.accentColor)
                                        .frame(width: 10, height: 10)
                                    
                                    Text(station.name)
                                        .foregroundColor(.white)
                                        .bold()
                                        .onTapGesture {
                                            // Update the viewModel based on currentSelection
                                            if currentSelection == .source {
                                                viewModel.selectedSource = station
                                            } else if currentSelection == .destination {
                                                viewModel.selectedDestination = station
                                            }
                                            // Reset states to hide search and show the main view
                                            isSearching = false
                                            currentSelection = .none
                                        }
                                }
                                .listRowBackground(Color(red: 0.1, green: 0.1, blue: 0.1))
                            }
        
                            .listStyle(.plain)
                            .scrollIndicators(.hidden)
                            .listRowSeparator(.hidden)
                        }
                        
                        Button("Calculate Route") {
                            viewModel.findPath()
                            viewModel.selectedSource = nil
                            viewModel.selectedDestination = nil
                            
                            withAnimation {
                                pathFound.toggle()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity) // This makes the button occupy the full width
                        .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .cornerRadius(15)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)


                        
                        Spacer()
  
                    }
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .cornerRadius(10)
                    .animation(.smooth)
                    .frame(height: UIScreen.main.bounds.height / (isSearching ? 1.5 : 4))
                    .cornerRadius(15)

                }
//                .animation(.default, value: showingOverlay)
//                .transition(.move(edge: .bottom)) // Adds a simple transition effect
                .edgesIgnoringSafeArea(.all)
            }


        }
        .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen

        
    }
    
    
    func filteredStations(_ query: String) -> [Station] {
        if query.isEmpty { return viewModel.stations }
        return viewModel.stations.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

}

extension View {
    func textOutlineEffect(_ text: String, textColor: Color, outlineColor: Color, lineWidth: CGFloat = 0) -> some View {
        self.overlay(
            Text(text)
                .bold()
                .foregroundColor(textColor)
        )
        .background(
            ZStack {
                Text(text)
                    .bold()
                    .offset(x: lineWidth, y: lineWidth)
                    .foregroundColor(outlineColor)
                Text(text)
                    .bold()

                    .offset(x: -lineWidth, y: -lineWidth)
                    .foregroundColor(outlineColor)
                Text(text)
                    .bold()

                    .offset(x: lineWidth, y: -lineWidth)
                    .foregroundColor(outlineColor)
                Text(text)
                    .bold()

                    .offset(x: -lineWidth, y: lineWidth)
                    .foregroundColor(outlineColor)
            }
        )
    }
}




#Preview {
    ContentView()
}
