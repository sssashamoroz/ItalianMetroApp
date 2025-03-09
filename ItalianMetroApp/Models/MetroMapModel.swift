//
//  MetroMapModel.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import Foundation

class MetroMap {
    private var adjacencyList: [Station: [Connection]] = [:]
    
    //Access Methods
    func getAllStations() -> [Station] {
        Array(adjacencyList.keys)
    }
    
    func getAllConnections() -> [Connection] {
        var allConnections: [Connection] = []
        var seenConnections: Set<String> = []
        
        for (station, connections) in adjacencyList {
            for connection in connections {
                let sortedIDs = [station.id, connection.to.id].sorted(by: { $0.uuidString < $1.uuidString })
                let connectionID = sortedIDs[0].uuidString + "-" + sortedIDs[1].uuidString

                if !seenConnections.contains(connectionID) {
                    allConnections.append(Connection(from: station, to: connection.to, weight: connection.weight))
                    seenConnections.insert(connectionID)
                }
            }
        }
        return allConnections
    }

    
    //Set Methods
    func addStation(_ station: Station) {
        if adjacencyList[station] == nil {
            adjacencyList[station] = []
        }
    }

    func addConnection(from: Station, to: Station, weight: Double) {
        
        let connection = Connection(from: from , to: to, weight: weight)
        adjacencyList[from]?.append(connection)
        
        // For an undirected graph, we also add a connection from 'to' to 'from'
        let reverseConnection = Connection(from: from, to: from, weight: weight)
        adjacencyList[to]?.append(reverseConnection)
        
        print("Adding connection from \(from.name) to \(to.name) with weight \(weight)")

    }
    
    
    //Find Path Methods
    func dijkstra(from source: Station, to destination: Station) -> [Station]? {
        var distances: [Station: Double] = [source: 0]
        var previous: [Station: Station?] = [source: nil]
        var queue = PriorityQueue<Station>(sort: { distances[$0, default: Double.infinity] < distances[$1, default: Double.infinity] })
        
        adjacencyList.keys.forEach { queue.enqueue($0) }
        
        while let current = queue.dequeue() {
            guard distances[current] != Double.infinity else { break }
            
            for connection in adjacencyList[current] ?? [] {
                let neighbor = connection.to
                let newDistance = distances[current, default: Double.infinity] + connection.weight
                
                if newDistance < distances[neighbor, default: Double.infinity] {
                    distances[neighbor] = newDistance
                    previous[neighbor] = current
                    queue.enqueue(neighbor) // This is not efficient; a priority queue with decrease-key operation is preferred
                }
            }
        }
                
        var path = constructPath(destination: destination, previous: previous)
        
        // Prepend the source station if it's not the first element
        if let firstStation = path?.first, firstStation != source {
            path?.insert(source, at: 0)
        }
        
        return path
    }
    
    private func constructPath(destination: Station, previous: [Station: Station?]) -> [Station]? {
        var path: [Station] = []
        var current: Station? = destination
        
        while let prev = current, let next = previous[prev] ?? nil {
            path.insert(prev, at: 0)
            current = next
        }
        
        print(path)
        return path.isEmpty ? nil : path
    }
}


//Helper for Dijkstra
struct PriorityQueue<Element> {
    private var elements: [Element] = []
    private let sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool) {
        self.sort = sort
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        elements.sort(by: sort)
    }
    
    mutating func dequeue() -> Element? {
        guard !isEmpty else { return nil }
        return elements.removeFirst()
    }
}
