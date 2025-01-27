local ls = require'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- 获取当前系统时间的函数
local function current_date_time()
    return os.date("%Y-%m-%d %H:%M")
end

-- 定义一个包含系统时间的片段
ls.add_snippets("cpp", {
    s("login", {
        t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "using ll = long long;",
            "//#define int ll",
            "",
            "",
            "void solve() {",
            "    "
        }),
        i(0),
        t({
            "",
            "}",
            "",
            "signed main() {",
            "    ios::sync_with_stdio(false);",
            "    cin.tie(nullptr);",
            "    int T = 1;",
            "    cin >> T;",
            "    while(T--) {",
            "        solve();",
            "    }",
            "    return 0;",
            "}",
            "",
            "/**",
            " * created: "
        }),
        f(current_date_time, {}),
        t({
            "",
            " **/"
        })
    })
})
