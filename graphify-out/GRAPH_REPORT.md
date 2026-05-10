# Graph Report - 06_connection_pool  (2026-05-10)

## Corpus Check
- 9 files · ~2,006 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 55 nodes · 56 edges · 9 communities (8 shown, 1 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 2 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `77ef08fc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]

## God Nodes (most connected - your core abstractions)
1. `基于 C++11 的高并发数据库连接池` - 9 edges
2. `常用命令` - 6 edges
3. `Docker Compose 运行` - 5 edges
4. `loadConfig()` - 4 edges
5. `关键设计说明` - 4 edges
6. `assignConfigItem()` - 3 edges
7. `ConnectionPool()` - 3 edges
8. `produceConnectionTask()` - 3 edges
9. `createConnection()` - 3 edges
10. `本地编译运行` - 3 edges

## Surprising Connections (you probably didn't know these)
- `ConnectionPool()` --calls--> `getConnection()`  [INFERRED]
  include/ConnectionPool.h → src/ConnectionPool.cpp
- `MySQL()` --calls--> `query()`  [INFERRED]
  include/MySQL.h → src/MySQL.cpp

## Communities (9 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.18
Nodes (11): 常用命令, 这套编排会启动什么, 初始化内容, 启动, code:bash (docker compose up --build), code:bash (docker compose up -d --build), code:bash (docker compose ps), code:bash (docker compose logs -f) (+3 more)

### Community 1 - "Community 1"
Cohesion: 0.36
Nodes (5): ConnectionPool(), ConnectionPool(), createConnection(), getConnection(), produceConnectionTask()

### Community 2 - "Community 2"
Cohesion: 0.25
Nodes (7): 项目特点, 目录结构, 成功运行的标志, 适合继续扩展的方向, 运行前说明, 基于 C++11 的高并发数据库连接池, code:text (.)

### Community 4 - "Community 4"
Cohesion: 0.6
Nodes (5): assignConfigItem(), loadConfig(), parseInt(), trim(), validate()

### Community 5 - "Community 5"
Cohesion: 0.4
Nodes (5): 本地编译运行, 依赖, 步骤, code:bash (bash ./autobuild.sh), code:conf (ip=127.0.0.1)

### Community 6 - "Community 6"
Cohesion: 0.4
Nodes (5): 关键设计说明, 为什么需要数据卷, code:conf (ip=mysql_db), 为什么 Docker 内不能写 `127.0.0.1`, 为什么需要 `healthcheck`

## Knowledge Gaps
- **19 isolated node(s):** `项目特点`, `code:text (.)`, `运行前说明`, `依赖`, `code:bash (bash ./autobuild.sh)` (+14 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `基于 C++11 的高并发数据库连接池` connect `Community 2` to `Community 0`, `Community 5`, `Community 6`?**
  _High betweenness centrality (0.211) - this node is a cross-community bridge._
- **Why does `Docker Compose 运行` connect `Community 0` to `Community 2`?**
  _High betweenness centrality (0.146) - this node is a cross-community bridge._
- **What connects `项目特点`, `code:text (.)`, `运行前说明` to the rest of the system?**
  _19 weakly-connected nodes found - possible documentation gaps or missing edges._