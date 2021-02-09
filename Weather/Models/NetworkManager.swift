//
//  NetworkManager.swift
//  Weather
//
//  Created by Bobrovko Ilya on 02.02.2021.
//

import Network

class NetworkManager {
    
    private let monitor: NWPathMonitor
    
    private let queue: DispatchQueue
    
    private var isInternetConnected = false
    
    func isInternetConntected() -> Bool {
        return isInternetConnected
    }
    
    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor")
        
        
        monitor.pathUpdateHandler = { path in
            self.isInternetConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
