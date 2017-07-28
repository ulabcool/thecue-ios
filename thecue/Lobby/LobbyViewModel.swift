//
//  LobbyViewModel.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import Firebase

class LobbyViewModel {

    private var refCurrentQueue: DatabaseReference?

    let tables: [Table]

    private(set) var items: [LobbyItem] = []
    private(set) var isLoading = false

    var onItemsChanged: (() -> Void)?
    var onLoadingChanged: (() -> Void)?
    private let currentUserId = Auth.auth().currentUser!.providerData[0].uid

    var isInTheQueue: Bool {
        return waitingGames.first {
            $0.player1.userId == currentUserId ||
            $0.player2?.userId == currentUserId }
        != nil
    }

    var isPlaying: Bool {
        return items.first?.player1.userId == currentUserId || items.first?.player2?.userId == currentUserId
    }

    var isTableFree: Bool {
        return items.count == 0
    }

    var waitingGames: [LobbyItem] {
        let queuing = items.count > 0 ? items.count - 1: 0
        return Array(items.suffix(queuing))
    }

    init?(tables: [Table]) {
        guard tables.count > 0 else {
            return nil
        }
        self.tables = tables
    }

    func didSelectTable(atIndex index: Int) {
        let table = tables[index]
        self.items = []
        onItemsChanged?()
        listenForQueue(withKey: table.queue)
    }

    func listenForQueue(withKey key: String) {
        refCurrentQueue = Database.database().reference(withPath: "queues/\(key)");
        refCurrentQueue?.observe(DataEventType.value, with: { (snapshot) in
            defer {
                self.onItemsChanged?()
            }
            guard let queue = snapshot.value as? [String: AnyObject] else {
                self.items = []
                return
            }
            let array = Array(queue.values)
            guard let allValues = array as? [[String: AnyObject]] else {
                self.items = []
                return
            }

            var newItems = allValues.flatMap {
                LobbyItem(withDictionnary: $0)
            }

            newItems.sort { $0.createdAt < $1.createdAt }
            self.items = newItems
        })
    }

    func didTapButton() {
        isInTheQueue || isPlaying ? leaveQueue() : joinQueue()
    }

    private func leaveQueue() {
        isLoading = true
        onLoadingChanged?()
        refCurrentQueue?.child(currentUserId).removeValue { (error, ref) in
            self.isLoading = false
            self.onLoadingChanged?()
        }
    }

    private func joinQueue() {
        let playerOne = [
            "userId": currentUserId,
            "name": Auth.auth().currentUser!.displayName ?? "Unknown",
        ]
        let item = ["player1": playerOne,
            "createdAt": ServerValue.timestamp()] as [String: Any]
        refCurrentQueue?.child(currentUserId).setValue(item) { (error, ref) in
            self.isLoading = false
            self.onLoadingChanged?()
        }
    }
}
