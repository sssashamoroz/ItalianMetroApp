//
//  MetroMapViewModel.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import Foundation

class MetroMapViewModel: ObservableObject {
    @Published var graph: MetroMap
    @Published var selectedSource: Station?
    @Published var selectedDestination: Station?
    @Published var path: [Station] = []

    init() {
        self.graph = MetroMapViewModel.createMetroGraph()
    }
    
    var stations: [Station] {
        graph.getAllStations()
    }
    
    var connections: [Connection] {
        graph.getAllConnections()
    }

    func selectStation(_ station: Station) {
        if selectedSource == nil {
            selectedSource = station
        } else if selectedDestination == nil {
            selectedDestination = station
        } else {
            // Resetting selections if two stations are already selected
            selectedSource = station
            selectedDestination = nil
            self.path = []
        }
    }

    func findPath() {
        if let source = selectedSource, let destination = selectedDestination {
            self.path = graph.dijkstra(from: source, to: destination) ?? []
            print(self.path)
        }
    }
    
    
    // Check if a station is selected
    func isStationSelected(_ station: Station) -> Bool {
        return station == selectedSource || station == selectedDestination
    }
    
    // Toggle the selection state of a station
    func toggleStationSelection(_ station: Station) {
        
        if selectedSource != nil && selectedDestination != nil {
            // Reset both selections
            selectedSource = nil
            selectedDestination = nil
            // Set the new station as the source
            selectedSource = station
        } else if selectedSource == station {
            // Deselect if the same station is selected as the source
            selectedSource = nil
        } else if selectedDestination == station {
            // Deselect if the same station is selected as the destination
            selectedDestination = nil
        } else if selectedSource == nil {
            // Select as source if no source is selected
            selectedSource = station
        } else if selectedDestination == nil {
            // Select as destination if no destination is selected and there is already a source
            selectedDestination = station
        }
        
        print("Selected Source: \(selectedSource?.name ?? "None")\nSelected Destination: \(selectedDestination?.name ?? "None")")
    }

    // Mock Data Creation
    static func createMetroGraph() -> MetroMap {
        let graph = MetroMap()
        
        // Line A 🟠 stations
        let battistini = Station(name: "Battistini", xCoordinate: -0.3, yCoordinate: 0, lines: ["A"], titleOrientation: "Up", accentColor: .orange)
        let cornella = Station(name: "Cornalla", xCoordinate: 0.7, yCoordinate: 0, lines: ["A"], titleOrientation: "Down",  accentColor: .orange)
        let baldoDegliUbaldi = Station(name: "Baldo degli Ubaldi", xCoordinate: 1.7, yCoordinate: 0, lines: ["A"], titleOrientation: "Up",  accentColor: .orange)
        let valleAurelia = Station(name: "Valle Aurelia", xCoordinate: 2.7, yCoordinate: 0, lines: ["A"], titleOrientation: "Down",  accentColor: .orange)
        let cipro = Station(name: "Cipro", xCoordinate: 3.7, yCoordinate: 0, lines: ["A"], titleOrientation: "Up",  accentColor: .orange)
        let lepanto = Station(name: "Lepanto", xCoordinate: 4.7, yCoordinate: 0, lines: ["A"], titleOrientation: "Down", accentColor: .orange)
        let spagna = Station(name: "Spagna", xCoordinate: 5.7, yCoordinate: 0.3, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let flaminio = Station(name: "Flaminio", xCoordinate: 6.7, yCoordinate: 0.6, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let barberini = Station(name: "Barberini", xCoordinate: 7.7, yCoordinate: 0.9, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let repubblica = Station(name: "Repubblica", xCoordinate: 8.7, yCoordinate: 1.2, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let terminiA = Station(name: "Termini", xCoordinate: 9.7, yCoordinate: 1.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let vittorioEmanuele = Station(name: "Vittorio Emanuele", xCoordinate: 10.7, yCoordinate: 1.8, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let manzoni = Station(name: "Manzoni", xCoordinate: 11.7, yCoordinate: 2.1, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let sanGiovanni = Station(name: "San Giovanni", xCoordinate: 12.7, yCoordinate: 2.4, lines: ["A"], titleOrientation: "Left", accentColor: .orange)
        let rediRoma = Station(name: "Re di Roma", xCoordinate: 13.7, yCoordinate: 2.7, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let ponteLungo = Station(name: "Ponte Lungo", xCoordinate: 14.7, yCoordinate: 2.7 + 0.3, lines: ["A"],titleOrientation: "Right", accentColor: .orange)
        let furioCamillo = Station(name: "Furio Camillo", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let colliAlbani = Station(name: "Colli Albani", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let arcoDiTravertino = Station(name: "Arco di Travertino", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let portaFurba = Station(name: "Porta Furba", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let numidioQuadrato = Station(name: "Numidio Quadrato", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let lucioSestio = Station(name: "Lucio Sestio", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let giulioAgricola = Station(name: "Giulio Agricola", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let subaugusta = Station(name: "Subaugusta", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let cinecitta = Station(name: "Cinecittà", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)
        let anagnina = Station(name: "Anagnina", xCoordinate: 14.7, yCoordinate: 2.7 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5 + 0.5, lines: ["A"], titleOrientation: "Right", accentColor: .orange)

        // Complete list of Line A 🟠 stations
        let lineAStations = [
            battistini, cornella, baldoDegliUbaldi, valleAurelia, cipro,
            lepanto, spagna, flaminio, barberini, repubblica, terminiA,
            vittorioEmanuele, manzoni, sanGiovanni, rediRoma, ponteLungo,
            furioCamillo, colliAlbani, arcoDiTravertino, portaFurba, numidioQuadrato,
            lucioSestio, giulioAgricola, subaugusta, cinecitta, anagnina
        ]

        // Adding Line A 🟠 stations to the graph
        lineAStations.forEach { graph.addStation($0) }

        // Line B 🟦 stations
        let rebibbia = Station(name: "Rebibbia", xCoordinate: 19.7, yCoordinate: 0.6 - 1.2, lines: ["B"], titleOrientation: "Right", accentColor: .blue)
        let ponteMammolo = Station(name: "Ponte Mammolo", xCoordinate: 18.7, yCoordinate: 0.6 - 0.9, lines: ["B"], titleOrientation: "Right", accentColor: .blue)
        let santaMaria = Station(name: "Santa Maria del Soccorso", xCoordinate: 17.7, yCoordinate: 0.6 - 0.6, lines: ["B"], titleOrientation: "Right", accentColor: .blue)
        let pietralata = Station(name: "Pietralata", xCoordinate: 16.7, yCoordinate: 0.6 - 0.3, lines: ["B"], titleOrientation: "Right", accentColor: .blue)
        let monti = Station(name: "Monti Tiburtini", xCoordinate: 15.7, yCoordinate: 0.6, lines: ["B"], titleOrientation: "Down", accentColor: .blue)
        let quintiliani = Station(name: "Quintiliani", xCoordinate: 14.7, yCoordinate: 0.6, lines: ["B"], titleOrientation: "Up", accentColor: .blue)
        let tiburtina = Station(name: "Tiburtina", xCoordinate: 13.7, yCoordinate: 0.6, lines: ["B"], titleOrientation: "Down", accentColor: .blue)
        let bolognaB = Station(name: "Bologna", xCoordinate: 12.7, yCoordinate: 0.6, lines: ["B"], titleOrientation: "Left", accentColor: .blue)  // Bologna B
        let policlinico = Station(name: "Policlinico", xCoordinate: 11.7, yCoordinate: 0.9, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let castroPretorio = Station(name: "Castro Pretorio", xCoordinate: 10.7, yCoordinate: 1.2, lines: ["B"], titleOrientation: "Right", accentColor: .blue)
        let terminiB = Station(name: "Termini B", xCoordinate: 9.5, yCoordinate: 1.56, lines: ["B"], titleOrientation: "Left", titleShown: false, accentColor: .blue) //Termini B
        let cavour = Station(name: "Cavour", xCoordinate: 8.7, yCoordinate: 1.8, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let colosseo = Station(name: "Colosseo", xCoordinate: 7.7, yCoordinate: 2.1, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let circoMassimo = Station(name: "Circo Massimo", xCoordinate: 6.7, yCoordinate: 2.4, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let piramide = Station(name: "Piramide", xCoordinate: 5.7, yCoordinate: 2.7, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let garbatella = Station(name: "Garbatella", xCoordinate: 5.7, yCoordinate: 3, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let basilicaSPaolo = Station(name: "Basilica S. Paolo", xCoordinate: 5.7, yCoordinate: 3.3, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let marconi = Station(name: "Marconi", xCoordinate: 5.7, yCoordinate: 3.6, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let magliana = Station(name: "Magliana", xCoordinate: 5.7, yCoordinate: 3.9, lines: ["B"], titleOrientation: "Left", accentColor: .blue)
        let palasport = Station(name: "Palasport", xCoordinate: 6.7, yCoordinate: 4.2, lines: ["B"], titleOrientation: "Up",accentColor: .blue)
        let fermi = Station(name: "Fermi", xCoordinate: 7.7, yCoordinate: 4.2, lines: ["B"], titleOrientation: "Down",accentColor: .blue)
        let laurentina = Station(name: "Laurentina", xCoordinate: 8.7, yCoordinate: 4.2, lines: ["B"], titleOrientation: "Up",accentColor: .blue)

        // Complete list of Line B 🟦 stations
        let lineBStations = [
            rebibbia, ponteMammolo, santaMaria, pietralata, monti, quintiliani, tiburtina, bolognaB, policlinico, castroPretorio, cavour, terminiB, colosseo, circoMassimo, piramide, garbatella, basilicaSPaolo, marconi, magliana, palasport, fermi, laurentina
        ]

        // Adding Line B 🟦 stations to the graph
        lineBStations.forEach { graph.addStation($0) }

        // Line B1 🔷 stations
        let bolognaB1 = Station(name: "Bologna B1", xCoordinate: 12.7, yCoordinate: 0.6 - 0.13, lines: ["B1"], titleOrientation: "Left", titleShown: false, accentColor: .indigo)
        let annibaliano = Station(name: "Annibaliano", xCoordinate: 12.7, yCoordinate: 0.6 - 0.5, lines: ["B1"], titleOrientation: "Left", accentColor: .indigo)
        let libia = Station(name: "Libia", xCoordinate: 12.7, yCoordinate: 0.6 - 1, lines: ["B1"], titleOrientation: "Left", accentColor: .indigo)
        let concadOro = Station(name: "Conca d'Oro", xCoordinate: 12.7, yCoordinate: 0.6 - 1.5, lines: ["B1"], titleOrientation: "Left", accentColor: .indigo)
        let jonio = Station(name: "Jonio", xCoordinate: 13.7, yCoordinate: 0.6 - 2, lines: ["B1"], titleOrientation: "Left", accentColor: .indigo)

        let lineB1Stations = [
            bolognaB1, annibaliano, libia, concadOro, jonio
        ]

        lineB1Stations.forEach { graph.addStation($0) }

        // Line C 🟩 Stations, corrected coordinates
        let sanGiovanniC = Station(name: "San Giovanni C", xCoordinate: 12.9, yCoordinate: 2.4, lines: ["C"], titleOrientation: "SomeOrientation", titleShown: false, accentColor: .green)
        let lodi = Station(name: "Lodi", xCoordinate: 13.9, yCoordinate: 2.4, lines: ["C"], titleOrientation: "Up", accentColor: .green)
        let pigneto = Station(name: "Pigneto", xCoordinate: 14.9, yCoordinate: 2.4, lines: ["C"], titleOrientation: "Down", accentColor: .green)
        let malatesta = Station(name: "Malatesta", xCoordinate: 15.9, yCoordinate: 2.4, lines: ["C"], titleOrientation: "Up", accentColor: .green)
        let teano = Station(name: "Teano", xCoordinate: 16.9, yCoordinate: 2.4, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let gardenie = Station(name: "Gardenie", xCoordinate: 17.4, yCoordinate: 2.7, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let mirti = Station(name: "Mirti", xCoordinate: 17.9, yCoordinate: 3.0, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let parcoDiCentocelle = Station(name: "Parco di Centocelle", xCoordinate: 18.4, yCoordinate: 3.3, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let alessandrino = Station(name: "Alessandrino", xCoordinate: 18.9, yCoordinate: 3.6, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let torreSpaccata = Station(name: "Torre Spaccata", xCoordinate: 19.4, yCoordinate: 3.9, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let torreMaura = Station(name: "Torre Maura", xCoordinate: 19.9, yCoordinate: 4.2, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let giardinetti = Station(name: "Giardinetti", xCoordinate: 20.4, yCoordinate: 4.5, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let torrenova = Station(name: "Torrenova", xCoordinate: 20.9, yCoordinate: 4.8, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let torreAngela = Station(name: "Torre Angela", xCoordinate: 21.4, yCoordinate: 5.1, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let torreGaia = Station(name: "Torre Gaia", xCoordinate: 21.9, yCoordinate: 5.4, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let grotteCeloni = Station(name: "Grotte Celoni", xCoordinate: 22.4, yCoordinate: 5.7, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let dueLeoniFontanaCandida = Station(name: "Due Leoni-Fontana Candida", xCoordinate: 22.9, yCoordinate: 6.0, lines: ["C"], titleOrientation: "SomeOrientation", accentColor: .green)
        let borghesiana = Station(name: "Borghesiana", xCoordinate: 23.4, yCoordinate: 6.3, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let bolognetta = Station(name: "Bolognetta", xCoordinate: 23.9, yCoordinate: 6.6, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let finocchio = Station(name: "Finocchio", xCoordinate: 24.4, yCoordinate: 6.9, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let graniti = Station(name: "Graniti", xCoordinate: 24.9, yCoordinate: 7.2, lines: ["C"], titleOrientation: "Right", accentColor: .green)
        let monteCompatriPantano = Station(name: "Monte Compatri-Pantano", xCoordinate: 25.4, yCoordinate: 7.5, lines: ["C"],titleOrientation: "Right", accentColor: .green)

        // Adding Line C 🟩 stations to the graph
        let lineCStations = [
            sanGiovanniC, lodi, pigneto, malatesta, teano, gardenie, mirti, parcoDiCentocelle,
            alessandrino, torreSpaccata, torreMaura, giardinetti, torrenova, torreAngela, torreGaia,
            grotteCeloni, dueLeoniFontanaCandida, borghesiana, bolognetta, finocchio, graniti, monteCompatriPantano
        ]

        lineCStations.forEach { graph.addStation($0) }


        
        // Manually adding connections for Line A 🟠
        graph.addConnection(from: battistini, to: cornella, weight: 1.0)
        graph.addConnection(from: cornella, to: baldoDegliUbaldi, weight: 1.0)
        graph.addConnection(from: baldoDegliUbaldi, to: valleAurelia, weight: 1.0)
        graph.addConnection(from: valleAurelia, to: cipro, weight: 1.0)
        graph.addConnection(from: cipro, to: lepanto, weight: 1.0)
        graph.addConnection(from: lepanto, to: spagna, weight: 1.0)
        graph.addConnection(from: spagna, to: flaminio, weight: 1.0)
        graph.addConnection(from: flaminio, to: barberini, weight: 1.0)
        graph.addConnection(from: barberini, to: repubblica, weight: 1.0)
        graph.addConnection(from: repubblica, to: terminiA, weight: 1.0)
        graph.addConnection(from: terminiA, to: vittorioEmanuele, weight: 1.0)
        graph.addConnection(from: vittorioEmanuele, to: manzoni, weight: 1.0)
        graph.addConnection(from: manzoni, to: sanGiovanni, weight: 1.0)
        graph.addConnection(from: sanGiovanni, to: rediRoma, weight: 1.0)
        graph.addConnection(from: rediRoma, to: ponteLungo, weight: 1.0)
        graph.addConnection(from: ponteLungo, to: furioCamillo, weight: 1.0)
        graph.addConnection(from: furioCamillo, to: colliAlbani, weight: 1.0)
        graph.addConnection(from: colliAlbani, to: arcoDiTravertino, weight: 1.0)
        graph.addConnection(from: arcoDiTravertino, to: portaFurba, weight: 1.0)
        graph.addConnection(from: portaFurba, to: numidioQuadrato, weight: 1.0)
        graph.addConnection(from: numidioQuadrato, to: lucioSestio, weight: 1.0)
        graph.addConnection(from: lucioSestio, to: giulioAgricola, weight: 1.0)
        graph.addConnection(from: giulioAgricola, to: subaugusta, weight: 1.0)
        graph.addConnection(from: subaugusta, to: cinecitta, weight: 1.0)
        graph.addConnection(from: cinecitta, to: anagnina, weight: 1.0)

        
        // Manually adding connections for Line B 🟦
        graph.addConnection(from: bolognaB, to: policlinico, weight: 1.0)
        graph.addConnection(from: policlinico, to: castroPretorio, weight: 1.0)
        graph.addConnection(from: castroPretorio, to: terminiB, weight: 1.0)
        graph.addConnection(from: terminiB, to: cavour, weight: 1.0)
        graph.addConnection(from: cavour, to: colosseo, weight: 1.0)
        graph.addConnection(from: colosseo, to: circoMassimo, weight: 1.0)
        graph.addConnection(from: circoMassimo, to: piramide, weight: 1.0)
        graph.addConnection(from: piramide, to: garbatella, weight: 1.0)
        graph.addConnection(from: garbatella, to: basilicaSPaolo, weight: 1.0)
        graph.addConnection(from: basilicaSPaolo, to: marconi, weight: 1.0)
        graph.addConnection(from: marconi, to: magliana, weight: 1.0)
        graph.addConnection(from: magliana, to: palasport, weight: 1.0)
        graph.addConnection(from: palasport, to: fermi, weight: 1.0)
        graph.addConnection(from: fermi, to: laurentina, weight: 1.0)
        graph.addConnection(from: rebibbia, to: ponteMammolo, weight: 1.0)
        graph.addConnection(from: ponteMammolo, to: santaMaria, weight: 1.0)
        graph.addConnection(from: santaMaria, to: pietralata, weight: 1.0)
        graph.addConnection(from: pietralata, to: monti, weight: 1.0)
        graph.addConnection(from: monti, to: quintiliani, weight: 1.0)
        graph.addConnection(from: quintiliani, to: tiburtina, weight: 1.0)
        graph.addConnection(from: tiburtina, to: bolognaB, weight: 1.0)
        
        // Manually adding connections for Line B1 🔷
        graph.addConnection(from: jonio, to: concadOro, weight: 1.0)
        graph.addConnection(from: concadOro, to: libia, weight: 1.0)
        graph.addConnection(from: libia, to: annibaliano, weight: 1.0)
        graph.addConnection(from: annibaliano, to: bolognaB1, weight: 1.0)
        
        //Manually adding connections for Line C 🟢
        graph.addConnection(from: sanGiovanniC, to: lodi, weight: 1.0)
        graph.addConnection(from: lodi, to: pigneto, weight: 1.0)
        graph.addConnection(from: pigneto, to: malatesta, weight: 1.0)
        graph.addConnection(from: malatesta, to: teano, weight: 1.0)
        graph.addConnection(from: teano, to: gardenie, weight: 1.0)
        graph.addConnection(from: gardenie, to: mirti, weight: 1.0)
        graph.addConnection(from: mirti, to: parcoDiCentocelle, weight: 1.0)
        graph.addConnection(from: parcoDiCentocelle, to: alessandrino, weight: 1.0)
        graph.addConnection(from: alessandrino, to: torreSpaccata, weight: 1.0)
        graph.addConnection(from: torreSpaccata, to: torreMaura, weight: 1.0)
        graph.addConnection(from: torreMaura, to: giardinetti, weight: 1.0)
        graph.addConnection(from: giardinetti, to: torrenova, weight: 1.0)
        graph.addConnection(from: torrenova, to: torreAngela, weight: 1.0)
        graph.addConnection(from: torreAngela, to: torreGaia, weight: 1.0)
        graph.addConnection(from: torreGaia, to: grotteCeloni, weight: 1.0)
        graph.addConnection(from: grotteCeloni, to: dueLeoniFontanaCandida, weight: 1.0)
        graph.addConnection(from: dueLeoniFontanaCandida, to: borghesiana, weight: 1.0)
        graph.addConnection(from: borghesiana, to: bolognetta, weight: 1.0)
        graph.addConnection(from: bolognetta, to: finocchio, weight: 1.0)
        graph.addConnection(from: finocchio, to: graniti, weight: 1.0)
        graph.addConnection(from: graniti, to: monteCompatriPantano, weight: 1.0)

        
        //Connection between Lines A 🟠 and 🔵 B
        graph.addConnection(from: terminiA, to: terminiB, weight: 1.0)
        
        //Connection Between B 🔵 and 🔷 B1
        graph.addConnection(from: bolognaB, to: bolognaB1, weight: 1.0)

        //Connectio Between A 🟠 and 🟢 C
        graph.addConnection(from: sanGiovanni, to: sanGiovanniC, weight: 1.0)


        return graph
    }
}
