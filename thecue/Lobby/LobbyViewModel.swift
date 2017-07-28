//
//  LobbyViewModel.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import Firebase

enum PlayerStatus {
    case inQueue
    case startingGame
    case playingGame
    case idle
}

class LobbyViewModel {

    private var refCurrentQueue: DatabaseReference?

    let tables: [Table]
    var playerStatus: PlayerStatus = .idle

    private(set) var items: [LobbyItem] = []
    private(set) var isLoading = false

    var onItemsChanged: (() -> Void)?
    var onLoadingChanged: (() -> Void)?
    private let currentUserId = Auth.auth().currentUser!.providerData[0].uid


//    var isPlaying: Bool {
//        return items.first?.player1.userId == currentUserId || items.first?.player2?.userId == currentUserId
//    }

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
        GameManager.shared.delegate = self
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
                self.gamesDidChange()
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

    private func gamesDidChange() {
        defer {
            self.onItemsChanged?()
        }

        if items.first?.player1.userId == currentUserId || items.first?.player2?.userId == currentUserId {
            playerStatus = .startingGame
            GameManager.shared.startGameSession()
            return
        }

        var isInTheQueue: Bool {
            return waitingGames.first {
                $0.player1.userId == currentUserId ||
                $0.player2?.userId == currentUserId }
            != nil
        }

        if isInTheQueue {
            playerStatus = .inQueue
            return
        }

        playerStatus = .idle
    }

    func didTapButton() {
        switch playerStatus {
        case .idle:
            joinQueue()
        case .inQueue:
            leaveQueue()
        case .startingGame:
            playerStatus = .playingGame
            self.onLoadingChanged?()
        case .playingGame:
            leaveQueue()
            GameManager.shared.manualGameEnd()
        }
    }

    fileprivate func leaveQueue() {
        isLoading = true
        onLoadingChanged?()
        refCurrentQueue?.child(currentUserId).removeValue { (error, ref) in
            self.isLoading = false
            self.onLoadingChanged?()
        }
    }

    private func joinQueue() {
        let currentUser = Auth.auth().currentUser!
        let playerOne = [
            "userId": currentUserId,
            "name": currentUser.displayName ?? "Unknown",
            "imageUrl": currentUser.photoURL?.absoluteString
        ]
        let item = ["player1": playerOne,
            "createdAt": ServerValue.timestamp()] as [String: Any]
        refCurrentQueue?.child(currentUserId).setValue(item) { (error, ref) in
            self.isLoading = false
            self.onLoadingChanged?()
        }
    }
}

 extension LobbyViewModel: GameManagerDelegateProtocol {
    func gameHasStarted() {
        if playerStatus == .startingGame {
            playerStatus = .playingGame
            self.onItemsChanged?()
        }
    }

    func gameHasFinished() {
        if playerStatus == .playingGame {
            leaveQueue()
        }
    }
}
