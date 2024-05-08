const std = @import("std");

const Args = struct { numbers: []i32, target: i32 };
const ArgsError = error{ InvalidArgument, MissingArgument };
const Result = struct { index_a: usize, index_b: usize };

pub fn main() !void {
    var allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer allocator.deinit();

    var cli_args = try std.process.argsAlloc(allocator);
    defer cli_args.deinit();

    const args: Args = process_args() catch |err| switch (err) {
        ArgsError.MissingArgument => std.debug.print("Argument was not provided", .{}),
        ArgsError.InvalidArgument => std.debug.print("Argument was not valid", .{}),
    };
    const result = process_args(args);

    if (result == null) {
        return;
    }
}

fn process_args(args: []const []const u8) ArgsError!Args {
    var result: Args = Args{ .target = undefined, .numbers = undefined };
    var i: usize = 0;

    if (args.len % 2 != 0)
        return ArgsError.MissingArgument;

    while (i < args.len) : (i += 2) {
        switch (args[i]) {
            "-t", "--target" => result.target = try std.fmt.parseInt(i32, args[i + 1], 10),
            "-l", "--list" => result.numbers = try std.fmt.parseInt(i32, args[i + 1], 10),
            else => return ArgsError.InvalidArgument,
        }
    }

    if (result.target == undefined or result.numbers == undefined)
        return ArgsError.MissingArgument;

    return result;
}

fn find(target: i32, numbers: []i32, allocator: *const std.mem.Allocator) ?Result {
    var map = std.AutoHashMap(i32, usize).init(allocator.*);
    defer map.deinit();

    var result: ?Result = null;
    for (numbers, 0..) |value, i| {
        const entry = map.get(value);
        if (entry != null) {
            result = Result{ .index_a = entry.?, .index_b = i };
            break;
        }

        map.put(target - value, i) catch |err| switch (err) {
            else => std.debug.print("leaky", .{}),
        };
    }

    return result;
}

test "parse args" {
    const argv = [_][]const u8{
        "program-name",
        "-t",
        "17",
        "-l",
        "[1, 7, 8, 10, 44, 9, 4, 3, 7, 54, 17]",
    };

    var numbers = [_]i32{ 1, 7, 8, 10, 44, 9, 4, 3, 7, 54, 17 };
    const input = Args{ .target = 17, .numbers = numbers[0..] };
    const parsed = process_args(argv[1..]);

    try std.testing.expectEqualDeep(input, parsed);
}

test "find" {
    var haystack = [_]i32{ 1, 7, 8, 10, 44, 9, 4, 3, 7, 54, 17 };
    const input = Args{ .target = 17, .numbers = haystack[0..] };
    const result = find(input.target, input.numbers, &std.testing.allocator);

    try std.testing.expect(result != null);
    try std.testing.expect(result.?.index_a == 1 and result.?.index_b == 3);
}
