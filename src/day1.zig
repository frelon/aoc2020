const std = @import("std");
const fmt = std.fmt;
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const input = @embedFile("day1.txt");

pub fn main() !void {
    std.debug.print("Fixing expense report...\n", .{});

    var report = std.AutoHashMap(i32, void).init(allocator);

    var lineIter = std.mem.split(u8, input, "\n");

    while (lineIter.next()) |line| {
        if (line.len == 0) {
            break;
        }

        const parsed = try fmt.parseInt(i32, line, 10);

        try report.put(parsed, {});
    }

    var keyIter = report.keyIterator();
    while (keyIter.next()) |key1| {
        if (report.get(2020 - key1.*)) |_| {
            std.debug.print("Part1: {d}+{d} = 2020, **={d}\n", .{ key1.*, 2020 - key1.*, key1.* * (2020 - key1.*) });
            break;
        }
    }

    var outerKeyIter = report.keyIterator();
    blk: while (outerKeyIter.next()) |key2| {
        var innerKeyIter = report.keyIterator();
        while (innerKeyIter.next()) |key1| {
            if (report.get(2020 - key1.* - key2.*)) |_| {
                std.debug.print("Part2: {d}+{d}+{d} = 2020, **={d}\n", .{ key1.*, key2.*, 2020 - key1.* - key2.*, key1.* * key2.* * (2020 - key1.* - key2.*) });
                break :blk;
            }
        }
    }

    std.debug.print("The end...\n", .{});
}
