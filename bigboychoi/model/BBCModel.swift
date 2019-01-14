import Foundation

struct Player {
    var name: String = ""
    var avatarURL: String = ""
}

struct HalfInning {
    var orderedPlayers: [Int] = []
    var runsScored: Int?
}

struct Game {
    var halfInnings = [HalfInning](repeating: HalfInning(), count:18)
    var playerScores: [(player: Int, score: Int)] = []
}
