import Foundation

struct Edge {
    var from: Int
    var to: Int
    var cost: UInt64
    var org: Bool

    init(_ from: Int, _ to: Int, _ cost: UInt64, _ org: Bool) {
        self.from = from
        self.to = to
        self.cost = cost
        self.org = org
    }
}

struct UnionFind {

    var parent: [Int]

    init(_ n: Int) {
        parent = Array<Int>(0...n)
    }

    mutating func find(_ p: Int) -> Int {
        if parent[p] == p {
            return p
        } else {
            parent[p] = find(parent[p])
            return parent[p]
        }
    }

    mutating func connected(_ p: Int, _ q: Int) -> Bool {
        return find(parent[p]) == find(parent[q])
    }

    mutating func union(_ p: Int, _ q: Int) {
        parent[p] = find(parent[q])
    }
}

func read() -> (N: Int, M: Int, D: UInt64, edges: [Edge]) {
    var line = readLine(strippingNewline: true)!
    var sp = line.components(separatedBy: " ")
    let N = Int(sp[0])!
    let M = Int(sp[1])!
    let D = UInt64(sp[2])!

    var edges = [Edge]()
    for i in 1...M {
        line = readLine(strippingNewline: true)!
        sp = line.components(separatedBy: " ")
        let from = Int(sp[0])!
        let to = Int(sp[1])!
        let cost = UInt64(sp[2])!

        if i < N {
            edges.append(Edge(from, to, cost, true))
        } else {
            edges.append(Edge(from, to, cost, false))
        }
    }

    return (N, M, D, edges)
}

func main(_ N: Int, _ M: Int, _ D: UInt64, _ edges:[Edge]) {
    var edges = edges
    edges.sort { $0.cost < $1.cost }

    var uf1 = UnionFind(N)
    var max: UInt64 = 0
    var count = 0
    var days = 0
    var i = 0

    for edge in edges {
        i += 1

        if count == N - 1 { break }

        if(!uf1.connected(edge.from, edge.to)) {
            uf1.union(edge.from, edge.to)
            count += 1
            max = edge.cost
            if !edge.org {
                days += 1
            }
        }
    }

    if edges[i - 1].org {
        print(days)
        return
    }

    var uf2 = UnionFind(N)

    for edge in edges {
        if(!uf2.connected(edge.from, edge.to)) {
            if edge.cost < max || (edge.cost == max && !edge.org) {
                uf2.union(edge.from, edge.to)
            } else if(edge.org && edge.cost <= D) {
                print(days - 1)
                return
            }
        }
    }

    print(days)
}

var (N, M, D, edges) = read()
main(N, M, D, edges)
