import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn process_ranges(
  ranges: List(#(Int, Int)),
  ranges_in_progress: List(#(Int, Int)),
) -> List(#(Int, Int)) {
  case ranges {
    [range, ..rest] -> {
      let combined = list.append(ranges_in_progress, [range])
      let #(overlapping, non_overlapping) =
        list.partition(combined, fn(r) {
          { r.0 <= range.0 && r.1 >= range.0 }
          || { r.0 >= range.0 && r.1 <= range.1 }
          || { r.0 <= range.1 && r.1 >= range.1 }
        })
      let int1 =
        list.fold(overlapping, range.0, fn(acc, r) {
          case r.0 < acc {
            True -> r.0
            False -> acc
          }
        })
      let int2 =
        list.fold(overlapping, range.1, fn(acc, r) {
          case r.1 > acc {
            True -> r.1
            False -> acc
          }
        })
      let ranges_in_progress = list.append(non_overlapping, [#(int1, int2)])
      process_ranges(rest, ranges_in_progress)
    }
    [] -> ranges_in_progress
  }
}

pub fn main() -> Nil {
  let assert Ok(content) = simplifile.read("input.txt")
  let assert Ok(#(ranges, numbers)) = string.split_once(content, "\n\n")
  let ranges =
    string.split(ranges, "\n")
    |> list.map(fn(range) {
      let assert Ok(#(str1, str2)) = string.split_once(range, "-")
      let assert Ok(int1) = int.parse(str1)
      let assert Ok(int2) = int.parse(str2)
      #(int1, int2)
    })
  let numbers =
    string.split(numbers, "\n")
    |> list.filter(fn(x) { !string.is_empty(x) })
    |> list.map(fn(x) {
      let assert Ok(int) = int.parse(x)
      int
    })
  let result1 =
    list.count(numbers, fn(num) {
      list.any(ranges, fn(range) {
        let #(int1, int2) = range
        num >= int1 && num <= int2
      })
    })
  io.println("Part 1 answer: " <> int.to_string(result1))
  let result2 =
    process_ranges(ranges, [])
    |> list.fold(0, fn(acc, r) { acc + r.1 - r.0 + 1 })
  io.print("Part 2 answer: " <> string.inspect(result2))
  Nil
}
