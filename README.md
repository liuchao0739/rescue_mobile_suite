# rescue_mobile_suite

智能应急救援平台（Rescue Platform）移动端 **Flutter Monorepo**，包含用户端与救援人员端两个 App，以及共享 packages。

| 属性 | 说明 |
|------|------|
| 平台 | [rescue_platform](https://github.com/liuchao0739) |
| 界面语言 | English (en-US) |
| 目标商店 | iOS App Store、Google Play |

## 仓库结构

```
rescue_mobile_suite/
├── apps/
│   ├── rescue_user_app/       # 用户端 — SOS、设备、救援跟踪
│   └── rescue_worker_app/     # 救援人员端 — 接单、导航、状态更新
├── packages/
│   ├── rescue_mobile_core/    # API、鉴权、配置、i18n
│   ├── rescue_mobile_models/  # 共享数据模型
│   ├── rescue_mobile_map/     # 地图组件
│   └── rescue_mobile_ui/      # 共享 UI 组件
├── docs/
│   └── rescue_platform_mvp_plan.md
└── melos.yaml
```

## 应用标识

| App | Android Package | iOS Bundle ID |
|-----|-----------------|---------------|
| rescue_user_app | `com.rescue.user` | `com.rescue.user` |
| rescue_worker_app | `com.rescue.worker` | `com.rescue.worker` |

## 环境要求

- Flutter SDK >= 3.9（stable）
- Dart SDK >= 3.9
- Xcode（iOS）、Android Studio / SDK（Android）
- [Melos](https://melos.invertase.dev/)（Monorepo 管理，推荐）

## 快速开始

### 1. 安装 Melos

```bash
dart pub global activate melos
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### 2. 安装依赖

```bash
cd rescue_mobile_suite
melos bootstrap
# 或手动：在各 apps/packages 下执行 flutter pub get
```

### 3. 运行应用

```bash
# 用户端
cd apps/rescue_user_app && flutter run

# 救援人员端
cd apps/rescue_worker_app && flutter run
```

使用 Melos 脚本：

```bash
melos run run:user    # 若已配置 melos scripts
melos run run:worker
```

## P0 功能范围（用户端）

- 登录 / 注册、首页、紧急 SOS（长按防误触）
- SOS 确认、事故类型、状态与救援跟踪
- 设备绑定、设备详情、消息、在线升级

## P0 功能范围（救援人员端）

- 登录、可接工单 / 我的工单、接单、导航
- 状态更新：On The Way → Arrived → Completed
- 联系用户、在线升级

## 相关仓库

| 仓库 | 说明 |
|------|------|
| [rescue_platform_api](https://github.com/liuchao0739/rescue_platform_api) | 后端 REST API |
| [rescue_ops_web](https://github.com/liuchao0739/rescue_ops_web) | 运营平台 Web |
| [rescue_iot_firmware](https://github.com/liuchao0739/rescue_iot_firmware) | 物联网设备固件 |
| [rescue_platform_infra](https://github.com/liuchao0739/rescue_platform_infra) | DevOps / 基础设施 |

## 文档

- [MVP 产品规划与技术方案](docs/rescue_platform_mvp_plan.md)

## 开发约定

- UI 文案默认 **英文**（en-US）
- SOS 状态枚举与后端一致：`CREATED` / `CONFIRMED` / `DISPATCHING` / `ON_THE_WAY` / `ARRIVED` / `COMPLETED` / `CANCELLED` / `ESCALATED`
- 新功能优先放入 `packages/`，App 层只做组合与路由

## License

Proprietary — Rescue Platform MVP
