const std = @import("std");

const JsonInput = struct {
    inputs: []Input,
};

const Input = struct {
    list: []const i32,
    target: i32,
    result: bool,
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    const json = try std.fs.cwd().readFileAlloc(allocator, "input.json", 25_000);
    defer allocator.free(json);

    const parsed = try parse_json(json, &allocator);

    for (parsed.value.inputs) |value| {
        const found = try check_list_for_sum(value.list, value.target, &allocator);
        if (found != value.result) {
            std.debug.print("Expected did not match result for target {d} in list {any}.\nExpected:{any}", .{ value.target, value.list, value.result });
            break;
        }
        if (found) {
            std.debug.print("Found possible sum of {d} in list {any}\n\n", .{ value.target, value.list });
        } else {
            std.debug.print("No combination found to get sum {d}\n\n", .{value.target});
        }
    }
}

fn parse_json(json: []const u8, allocator: *const std.mem.Allocator) !std.json.Parsed(JsonInput) {
    var diagnostics = std.json.Diagnostics{};
    errdefer std.debug.print("\n\n\n\nhuuuuuuuuuuuuuuu\n\n\n\n\n{}", .{diagnostics.getLine()});

    // Remember to add diagnostics
    var scanner = std.json.Scanner.initCompleteInput(allocator.*, json);
    scanner.enableDiagnostics(&diagnostics);
    defer scanner.deinit();

    return try std.json.parseFromTokenSource(JsonInput, allocator.*, &scanner, .{});
}

fn check_list_for_sum(list: []const i32, k: i32, allocator: *const std.mem.Allocator) !bool {
    var map = std.AutoHashMap(i32, i32).init(allocator.*);
    defer map.deinit();

    for (list) |v| {
        if (map.get(v) != null) {
            return true;
        }

        try map.put(k - v, v);
    }

    return false;
}

test "checks list for sum" {
    const allocator = std.testing.allocator;

    const input1 = Input{ .list = &[_]i32{ 10, 15, 3, 7 }, .target = 17, .result = true };

    const input2 = Input{ .list = &[_]i32{ 15, 3, 7 }, .target = 17, .result = false };

    const found1 = try check_list_for_sum(input1.list, input1.target, &allocator);
    const found2 = try check_list_for_sum(input2.list, input2.target, &allocator);

    try std.testing.expect(found1 == input1.result);
    try std.testing.expect(found2 == input2.result);
}
