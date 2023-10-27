const std = @import("std");
const fmt = std.fmt;
const alloc = std.heap.page_allocator;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    var day: []const u8 = "day1";
    if (b.args) |args| {
        day = if (args.len > 0) args[0] else "day1";
    }

    const exeName = try std.fmt.allocPrint(alloc, "aoc2020{s}", .{day});
    defer alloc.free(exeName);

    const srcPath = try std.fmt.allocPrint(alloc, "src/{s}.zig", .{day});
    defer alloc.free(srcPath);

    const exe = b.addExecutable(.{
        .name = exeName,
        .root_source_file = .{ .path = srcPath },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
