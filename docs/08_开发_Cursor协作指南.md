# 智能应急救援平台 — Cursor 协作指南

> **全流程**：[00_全流程总览.md](./00_全流程总览.md)  
> 产品/设计会话分工：[02_产品_需求与原型学习指南.md](./02_产品_需求与原型学习指南.md) §六  
> 更新日期：2026-06-02  
> **推荐**：全部使用 **Cursor**（产品 / 设计 / 开发 / 运维 / 测试 分 Chat）

---

## 文档说明

| 序号 | 文档 | Cursor 用途 |
|------|------|-------------|
| 00 | [00_全流程总览.md](./00_全流程总览.md) | 阶段与文档索引 |
| 01～02 | 产品 | PRD、用户故事、原型 |
| 03 | 设计 | Token、Widget |
| 04～08 | 开发 | 工程、前端、后端、本文 |
| 09 | 运维 | compose、SSH 脚本 |
| 10 | 测试 | 用例、排错 |

> 下文保留 OpenCode / CodeBuddy 分工作**任务拆分参考**；工具统一 Cursor 时，将「谁来做」映射为「新开 Cursor 会话 + @ 对应文档」。

---

## 一、为什么要分 IDE

本项目包含 **5 个独立 Git 仓库**（`rescue_mobile_suite`、`rescue_ops_web`、`rescue_platform_api`、`rescue_iot_firmware`、`rescue_platform_infra`），P0 核心闭环跨越硬件 MQTT、后端 API、运营 Web、移动端。

三个 IDE 均使用 Auto 模型时，**模型能力接近**，分工应主要依据：

1. **IDE 工具特性**（Agent、终端并行、前端/design-to-code、腾讯云集成等）
2. **仓库边界**（避免多 IDE 同时改同一仓库造成冲突）
3. **契约先行**（OpenAPI、MQTT Topic、WebSocket 事件协议定稿后再并行）

本地工程目录（非 Git 根，仅聚合 clone）：

```
~/rescue_platform/
├── rescue_mobile_suite/
├── rescue_ops_web/
├── rescue_platform_api/
├── rescue_iot_firmware/
└── rescue_platform_infra/
```

---

## 二、核心原则

### 2.1 一仓一主 IDE

**同一仓库同一时刻只让一个 IDE 作为主写入方**，否则极易在 `main` 上互相覆盖。

| 原则 | 说明 |
|------|------|
| 按仓库分，不按任务随机分 | 每个 IDE 有明确主责仓库 |
| 分支隔离 | 各 IDE 使用固定前缀分支（见 §五） |
| 契约先行 | API / MQTT / WS 协议定稿后再跨端对接 |
| 文档同源 | 三 IDE 的项目说明均指向 `docs/01_产品_MVP规划与技术方案.md` |

### 2.2 P0 核心闭环（对齐 MVP 规划）

```
设备激活/绑定 SIM → 用户绑定设备 → 触发 SOS → 平台秒级收到
→ 后台地图弹出 → 调度员派单 → 救援人员接单前往 → 用户看进度 → 完成归档
```

---

## 三、三 IDE 推荐分工

| IDE | 主责仓库 | 适合做什么 | 不太适合 |
|-----|----------|------------|----------|
| **Cursor** | `rescue_platform_api` + 跨仓协调 | P0 后端（SOS API、migrations、MQTT Worker）、OpenAPI 契约、Flutter 共享 packages、Git PR/CI、文档同步 | 大量 UI 原型迭代 |
| **CodeBuddy** | `rescue_ops_web` | React + Ant Design Pro、调度大屏 `/dispatch-screen`、SOS 中心/地图弹窗、表格表单 RBAC、设计稿转代码 | Go 后端、嵌入式 C/C++ |
| **OpenCode** | `rescue_platform_infra` + 后端辅助 | `docker compose` 起 EMQX/PostgreSQL/Redis、联调脚本、并行跑 `go test` / `flutter test`、多 Agent 推进 mqtt_worker / ws_server | 需要复杂 UI 预览的前端页面 |

### 3.1 各 IDE 角色定位（一句话）

| IDE | 角色 |
|-----|------|
| **Cursor** | 架构师 + 后端 + 移动端 + Git/PR 中枢 |
| **CodeBuddy** | 运营平台 / Web 前端工厂 |
| **OpenCode** | DevOps + 联调测试 + 后端 Worker 并行开发 |

### 3.2 特殊说明

| 场景 | 推荐 IDE / 工具 |
|------|-----------------|
| Flutter 真机调试 | **Android Studio** 跑 App；**Cursor** 打开 `rescue_mobile_suite` 根目录改共享 packages（见开发手册 §五、§六） |
| IoT 固件 `rescue_iot_firmware` | P0 阶段可用 **Cursor** 写协议/MQTT 骨架；真机联调时再切专用嵌入式工具 |
| 跨 5 仓批量 push | 终端脚本（见开发手册 §3.2），不依赖特定 IDE |

---

## 四、P0 阶段并行节奏

按 **契约先行、三 IDE 并行** 推进：

```
                    ┌─────────────────────────────────┐
                    │  Cursor                         │
                    │  rescue_platform_api            │
                    │  SOS API + DB + Worker          │
                    │  OpenAPI / MQTT 契约            │
                    └────────────┬────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│ OpenCode        │   │ OpenCode        │   │ CodeBuddy       │
│ infra           │   │ 联调脚本/压测    │   │ rescue_ops_web  │
│ EMQX+PG+Redis   │──▶│ go test 等      │   │ SOS中心+地图    │
└─────────────────┘   └─────────────────┘   └─────────────────┘
```

### 4.1 分周任务建议

| 阶段 | Cursor | OpenCode | CodeBuddy |
|------|--------|----------|-----------|
| **第 1–2 周** | MQTT Topic 定稿、migrations、SOS REST API | EMQX + DB 本地环境、SOS 端到端验证脚本 | 读 OpenAPI，搭 SOS 列表/详情页骨架（Mock 数据） |
| **第 3–4 周** | `mqtt_worker` 消费 SOS、Redis 实时状态 | 延迟/送达率压测（目标 < 3s） | 地图弹窗 + WebSocket 接事件流 |
| **第 5 周起** | Flutter `rescue_user_app` 对接 API | CI / 监控脚本 | 调度派单 UI + 大屏路由 |

### 4.2 合并顺序（有依赖时）

```
infra（OpenCode）→ api 契约（Cursor）→ ops_web（CodeBuddy）→ mobile（Cursor）
```

同一仓库内：**先合并 infra/API，再合并前端**。

---

## 五、日常协作规范

### 5.1 分支命名

每个 IDE 使用固定前缀，便于 SourceTree 辨认：

```
cursor/sos-api-migrations
opencode/emqx-compose
codebuddy/sos-center-page
```

### 5.2 契约文件（跨 IDE 对接依据）

| 契约 | 位置 | 维护方 |
|------|------|--------|
| MQTT Topic | `01_产品_MVP规划与技术方案.md` 附录 A | Cursor 主写，OpenCode 联调验证 |
| REST API | `rescue_platform_api/docs/openapi.yaml`（待建） | Cursor |
| WebSocket 事件 | `rescue_platform_api/docs/ws_events.md`（待建） | Cursor 编写，CodeBuddy 消费 |
| UI 状态枚举 | MVP 规划 §3.2（`CREATED` / `CONFIRMED` / …） | 三端共用，变更先改文档 |

**规则**：后端 API 未定时，CodeBuddy 前端只用 Mock，不要硬对接字段。

### 5.3 各 IDE 项目上下文配置

| IDE | 建议配置 |
|-----|----------|
| **Cursor** | `.cursor/rules` 中写明本仓职责与禁止修改的目录 |
| **OpenCode** | 各仓库根目录执行 `opencode init`，生成 `AGENTS.md` |
| **CodeBuddy** | 使用 `@workspace` 引用 `docs/01_产品_MVP规划与技术方案.md` |

三份说明均应指向同一份 MVP 规划，避免上下文不一致。

### 5.4 文档同步

- 规划/协作文档修改后，同步到各 Git 仓库的 `docs/` 目录（与开发手册约定一致）
- 避免只改坚果云、不同步 Git，导致三 IDE 读取的上下文版本不一致

---

## 六、典型工作日用法

| 时段 | 操作 |
|------|------|
| **上午** | **Cursor**：确定当天 API/DB 改动，推 `cursor/*` 分支 |
| **上午（并行）** | **OpenCode**：在 `rescue_platform_infra` 起环境，跑 SOS 联调脚本 |
| **下午** | **CodeBuddy**：按 OpenAPI 做运营平台 SOS 页（Mock → 真接口） |
| **傍晚** | **Cursor**：Flutter 或 Worker 对接刚定稿的 API |
| **提交前** | 各 IDE 只 push 自己的分支；按 §4.2 依赖顺序在 SourceTree 合并 |

---

## 七、需要避免的坑

| # | 问题 | 建议 |
|---|------|------|
| 1 | 三 IDE 同时改 `rescue_platform_api` | 冲突概率最高；分分支、分模块（如 Cursor 写 `cmd/api`，OpenCode 写 `cmd/mqtt_worker`） |
| 2 | 无 OpenAPI 就让 CodeBuddy 对接后端 | 字段反复变更，前端返工多 |
| 3 | 在 CodeBuddy 主开发 Flutter | 开发手册已建议 Cursor + Android Studio；Monorepo + Melos + 真机更稳 |
| 4 | 文档只改本地不同步 Git | 三 IDE 上下文分裂，联调时对不齐 |
| 5 | 父目录 `~/rescue_platform` 当 Git 根 | 5 个仓库需分别 Open / clone（见开发手册 §3.2） |

---

## 八、与 MVP 优先级对照

| 优先级 | 事项 | 主责 IDE | 负责仓库 |
|--------|------|----------|----------|
| P0 | MQTT Topic 协议定稿 | Cursor + OpenCode 验证 | iot_firmware + platform_api |
| P0 | 数据库 ER / migrations 初版 | Cursor | platform_api |
| P0 | SOS API + EMQX 联调 | Cursor + OpenCode | platform_api + infra |
| P1 | 用户端 SOS 流程对接 API | Cursor | rescue_mobile_suite |
| P1 | 运营平台 SOS 中心 + 地图 | CodeBuddy | rescue_ops_web |

---

## 九、后续可补充的落地文件

| 文件 | 用途 | 建议负责 |
|------|------|----------|
| `rescue_platform_api/docs/openapi.yaml` | REST 契约，供 CodeBuddy 对接 | Cursor |
| `rescue_platform_api/docs/ws_events.md` | WebSocket 事件协议 | Cursor |
| 各仓库 `AGENTS.md` | OpenCode 项目上下文 | OpenCode init |
| `.cursor/rules/*.mdc` | Cursor 分仓规则 | Cursor |

---

## 十、相关链接

- GitHub 仓库列表：https://github.com/liuchao0739?tab=repositories  
- MVP 规划：[01_产品_MVP规划与技术方案.md](./01_产品_MVP规划与技术方案.md)  
- 开发手册：[04_开发_工程手册.md](./04_开发_工程手册.md)  
- 本地工程路径：`~/rescue_platform/`

---

*文档版本：v1.0 | 2026-06-02*
