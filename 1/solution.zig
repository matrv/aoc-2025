const std = @import("std");

pub fn main() !void {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var buf: [4096]u8 = undefined;
    var reader = file.reader(&buf);
    var cur_num: i32 = 50;
    var counter1: i32 = 0;
    var counter2: i32 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        const first_char = line[0];
        const other_chars = line[1..];
        const num = try std.fmt.parseInt(usize, other_chars, 10);
        for (0..num) |_| {
            if (first_char == 'L') {
                cur_num -= 1;
            } else {
                cur_num += 1;
            }
            while (cur_num >= 100) {
                cur_num -= 100;
            }
            while (cur_num < 0) {
                cur_num += 100;
            }
            if (cur_num == 0) {
                counter2 += 1;
            }
        }

        if (cur_num == 0) {
            counter1 += 1;
        }
    }
    std.debug.print("Part 1 answer: {d}\n", .{counter1});
    std.debug.print("Part 2 answer: {d}\n", .{counter2});
}
