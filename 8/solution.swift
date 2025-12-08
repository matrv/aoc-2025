import Foundation

struct Point {
    let x: Int
    let y: Int
    let z: Int
    let id: Int
}

var points: [Point] = []

let filePath = "input.txt"
let numberOfConnections = 1000;

if let fileHandle = FileHandle(forReadingAtPath: filePath) {
    defer {
        fileHandle.closeFile()
    }

    let buffer = 32768
    while true {
        let data = fileHandle.readData(ofLength: buffer)
        if data.isEmpty {
            break
        }
        if let content = String(data: data, encoding: .utf8) {
            let lines = content.split(separator: "\n", omittingEmptySubsequences: false)
            var i = 0;
            for line in lines {
                if line.isEmpty {
                    continue
                }
                let numbers = line.components(separatedBy: ",");
                let x = Int(numbers[0])!
                let y = Int(numbers[1])!
                let z = Int(numbers[2])!
                let point = Point(x: x, y: y, z: z, id: i)
                i += 1
                points.append(point)
            }
        }
    }
} else {
    print("Failed to open file at path: \(filePath)")
}


struct DistanceResult {
    let point1Id: Int
    let point2Id: Int
    let distance: Int
}

var distances: [DistanceResult] = []

for point1 in points {
    for point2 in points {
        if point1.id >= point2.id {
            continue
        }
        let xF = abs(point1.x - point2.x)
        let yF = abs(point1.y - point2.y)
        let zF = abs(point1.z - point2.z)
        let distance = xF*xF + yF*yF + zF*zF
        distances.append(
            DistanceResult(
                point1Id: point1.id,
                point2Id: point2.id,
                distance: distance
            )
        )
    }
}

distances.sort { $0.distance < $1.distance }

var distances2 = distances;

var circuits: [[Int]] = []

for _ in 0..<numberOfConnections {
    let result = distances.removeFirst();
    let point1Circuit = circuits.firstIndex(where: { 
        $0.contains(where: {
            $0 == result.point1Id
        })
    })
    let point2Circuit = circuits.firstIndex(where: {
        $0.contains(where: {
            $0 == result.point2Id
        })
    })
    if point1Circuit == nil && point2Circuit == nil {
        circuits.append([result.point1Id, result.point2Id])
    } else if point1Circuit != nil && point2Circuit == nil {
        circuits[point1Circuit!].append(result.point2Id)
    } else if point1Circuit == nil && point2Circuit != nil {
        circuits[point2Circuit!].append(result.point1Id)
    } else if point1Circuit != point2Circuit {
        let elements = circuits[point2Circuit!]
        circuits[point1Circuit!].append(contentsOf: elements)
        circuits.remove(at: point2Circuit!)
    }
}

var result = 1;

let circuitSizes = circuits.map { $0.count } .sorted { $0 > $1 }

for i in 0...2 {
    result *= circuitSizes[i]
}

print("Part 1 answer:", result)

var circuits2: [[Int]] = []

while distances2.count > 0 {
    let result = distances2.removeFirst();
    let point1Circuit = circuits2.firstIndex(where: { 
        $0.contains(where: {
            $0 == result.point1Id
        })
    })
    let point2Circuit = circuits2.firstIndex(where: {
        $0.contains(where: {
            $0 == result.point2Id
        })
    })
    if point1Circuit == nil && point2Circuit == nil {
        circuits2.append([result.point1Id, result.point2Id])
    } else if point1Circuit != nil && point2Circuit == nil {
        circuits2[point1Circuit!].append(result.point2Id)
    } else if point1Circuit == nil && point2Circuit != nil {
        circuits2[point2Circuit!].append(result.point1Id)
    } else if point1Circuit != point2Circuit {
        let elements = circuits2[point2Circuit!]
        circuits2[point1Circuit!].append(contentsOf: elements)
        circuits2.remove(at: point2Circuit!)
    }
    if (circuits2.count == 1 && circuits2[0].count == points.count) {
        let point1 = points[result.point1Id]
        let point2 = points[result.point2Id]
        print("Part 2 answer:", point1.x * point2.x)
        break;
    }
}
