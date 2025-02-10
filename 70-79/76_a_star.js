

bitmap = [
    [1, 0, 0, 0],
    [1, 1, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
]


function ones_and_zeros(point) {
  return (point[1] == point[2] == point[3]) ? 1 : 0
}
const fs = require('fs');
const bmp = require('bmp-js');

const filePath = './example.bmp';

// Read the BMP file
fs.readFile(filePath, (err, data) => {
  decoded_data =  bmp.decode(data)
    // data.map(pixel => console.log(pixel))
  console.log(decoded_data)
  the_data = decoded_data.data
  // console.log(the_data)
  final_array = []
  sub_array = []
  // console.log()
  console.log(the_data.length)
  // 54

  for (let i = 0; i < the_data.length; i +=4) {
    
    // value = 
    // if(i >= 53) {
      console.log(`${i}: ${the_data[i]} ${the_data[i+1]} ${the_data[i+2]} ${the_data[i+3]}`)

      if (sub_array.length == decoded_data.width) {
          final_array.push(sub_array) 
          sub_array = [the_data[i]]
        } else {
          sub_array.push(ones_and_zeros(the_data[i]))
      }

    // }
  }
  // final_array.push(sub_array)
  console.log(final_array[0].length)
  console.log(final_array)
  if (err) {
    console.error(`Error reading file: ${err.message}`);
    return;
  }

})
// function a_star(bitmap, start, end) {
//     for(let i = 0; i<)
// }

/*
/ A* finds a path from start to goal.
// h is the heuristic function. h(n) estimates the cost to reach goal from node n.
function A_Star(start, goal, h)
    // The set of discovered nodes that may need to be (re-)expanded.
    // Initially, only the start node is known.
    // This is usually implemented as a min-heap or priority queue rather than a hash-set.
    openSet := {start}

    // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from the start
    // to n currently known.
    cameFrom := an empty map

    // For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    gScore := map with default value of Infinity
    gScore[start] := 0

    // For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
    // how cheap a path could be from start to finish if it goes through n.
    fScore := map with default value of Infinity
    fScore[start] := h(start)

    while openSet is not empty
        // This operation can occur in O(Log(N)) time if openSet is a min-heap or a priority queue
        current := the node in openSet having the lowest fScore[] value
        if current = goal
            return reconstruct_path(cameFrom, current)

        openSet.Remove(current)
        for each neighbor of current
            // d(current,neighbor) is the weight of the edge from current to neighbor
            // tentative_gScore is the distance from start to the neighbor through current
            tentative_gScore := gScore[current] + d(current, neighbor)
            if tentative_gScore < gScore[neighbor]
                // This path to neighbor is better than any previous one. Record it!
                cameFrom[neighbor] := current
                gScore[neighbor] := tentative_gScore
                fScore[neighbor] := tentative_gScore + h(neighbor)
                if neighbor not in openSet
                    openSet.add(neighbor)

    // Open set is empty but goal was never reached
    return failure

*/