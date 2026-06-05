# 智能应急救援平台 — 后端学习与实践（Spring Boot 路线）

> **全流程**：[00_全流程总览.md](./00_全流程总览.md)  
> 产品：[01_产品_MVP规划与技术方案.md](./01_产品_MVP规划与技术方案.md)  
> 运维：[09_运维_部署与环境指南.md](./09_运维_部署与环境指南.md)  
> 测试：[10_测试_验收与测试指南.md](./10_测试_验收与测试指南.md)  
> 对照路线：[07_开发_后端_Go路线.md](./07_开发_后端_Go路线.md)  
> 仓库：`~/rescue_platform/rescue_platform_api`  
> 更新日期：2026-06-02

---

## 文档说明

| 适用人群 | 有 Spring Boot + MySQL + Redis 经验，希望**最快跑通 MVP** |
|----------|----------------------------------------------------------|
| 本项目差异 | MySQL → **PostgreSQL**；无 Apollo；新增 **EMQX/MQTT** |
| 学习周期 | 约 **6 周**（边学边做 P0） |
| 推荐 IDE | **Cursor** 主写 API；**OpenCode** 跑 infra / 联调脚本 |

---

## 一、技术栈对照（你熟悉的 → 本项目）

| 你熟悉的 | 本项目 MVP | 说明 |
|----------|------------|------|
| Spring Boot 2/3 | **Spring Boot 3.x** | 建议 JDK 17 或 21 |
| MySQL | **PostgreSQL 15 + PostGIS** | GIS、JSONB 更适合 SOS 时间线 |
| Redis | **Redis 7** | 设备在线、最新 GPS、SOS 实时状态 |
| MyBatis / JPA | **MyBatis-Plus 或 Spring Data JPA** | 二选一，团队单人建议 JPA 起步快 |
| Apollo 配置中心 | **不需要（MVP）** | `.env` + `application.yml` + Docker Compose |
| Eureka / Nacos | **不需要（MVP）** | 单体内先跑通，后期再拆微服务 |
| RabbitMQ | **RabbitMQ（MVP）** | GPS/心跳削峰；SOS 也可直连处理 |
| — | **EMQX 5.x** | 设备 MQTT 接入（新技能重点） |
| — | **独立进程** | `mqtt_worker`、`ws_server`、`notify_worker` 可先同仓不同 module |

---

## 二、开发工具安装（macOS）

### 2.1 必装

```bash
# JDK（Homebrew）
brew install openjdk@21
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc

# 构建工具（任选）
brew install maven
# 或项目用 Gradle Wrapper，clone 后 ./gradlew 即可

# 数据库客户端（任选）
brew install --cask tableplus
# 或 DBeaver

# 容器
brew install --cask docker

# API 调试
brew install --cask bruno
# 或 Postman

# MQTT 模拟设备
brew install --cask mqttx
```

### 2.2 验证

```bash
java -version          # 应显示 21
docker --version
cd ~/rescue_platform/rescue_platform_infra
docker compose version
```

### 2.3 可选（部署阶段）

| 工具 | 用途 |
|------|------|
| `ssh`（系统自带） | 登录云服务器 |
| Termius | 多服务器 SSH 管理 |
| `gh` | GitHub CLI，PR 与 Actions |

---

## 三、推荐工程结构（`rescue_platform_api`）

```
rescue_platform_api/
├── docs/
│   ├── openapi.yaml              # REST 契约（Cursor 生成，CodeBuddy 消费）
│   └── ws_events.md              # WebSocket 事件协议
├── src/main/java/com/rescue/
│   ├── RescuePlatformApplication.java
│   ├── config/                   # Security、Redis、MQTT、WebSocket
│   ├── controller/               # REST
│   ├── service/
│   ├── repository/
│   ├── domain/                   # Entity、DTO
│   ├── mqtt/                     # MQTT 监听（或独立 mqtt-worker 模块）
│   └── ws/                       # WebSocket 推送
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   └── db/migration/             # Flyway：V1__init.sql ...
├── mqtt-worker/                  # 可选：后期拆独立 Spring Boot 应用
├── docker/
│   └── Dockerfile
└── pom.xml 或 build.gradle.kts
```

**MVP 建议**：先 **单体 Spring Boot** + 内嵌 MQTT 监听；SOS 量上来后再把 `mqtt-worker` 拆成独立 jar 部署。

---

## 四、6 周学习 + 实践计划

### 第 1 周：PostgreSQL + 本地环境

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| PostgreSQL 与 MySQL 差异（JSONB、GIS） | 理解 `sos_events` 时间线字段设计 |
| Flyway / Liquibase migrations | `users`、`devices`、`sos_events` 初版表 |
| Docker Compose 起 PG + Redis | 配合 `rescue_platform_infra` |

**每日任务示例**：

- Day 1–2：跟 Cursor 在 `rescue_platform_infra` 写 `docker-compose.yml`（postgres、redis、emqx）
- Day 3–4：Spring Boot 连 PG，跑通 health check
- Day 5：Flyway `V1__init.sql` 提交到 `rescue_platform_api`

**Cursor 提示词示例**：

> 在 rescue_platform_api 用 Spring Boot 3 + Flyway 创建 users、devices、sos_events 表，字段对齐 01_产品_MVP规划与技术方案.md §4.6，PostgreSQL 语法。

---

### 第 2 周：REST API + JWT 鉴权

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| Spring Security 6 + JWT | 登录、Token 刷新、权限校验 |
| 统一响应体、错误码 | 对齐 MVP 英文状态枚举 |
| OpenAPI / SpringDoc | `docs/openapi.yaml` |

**P0 接口（先做这些）**：

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/v1/auth/login` | 手机/邮箱登录 |
| POST | `/api/v1/sos` | 创建 SOS |
| GET | `/api/v1/sos/{id}` | 查询 SOS |
| PATCH | `/api/v1/sos/{id}/status` | 状态流转 |

**状态枚举**（与 MVP 一致）：`CREATED` → `CONFIRMED` → `DISPATCHING` → `ON_THE_WAY` → `ARRIVED` → `COMPLETED` / `CANCELLED` / `ESCALATED`

---

### 第 3 周：Redis + 业务服务

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| Spring Data Redis | 设备在线、最新 GPS 缓存 |
| 事务与幂等 | SOS 重复上报去重 |
| 设备 / SIM 基础 API | `devices`、`sim_cards` CRUD |

**Redis Key 约定（建议）**：

```
rescue:device:{deviceId}:online      → 1/0
rescue:device:{deviceId}:gps       → JSON {lat,lng,ts}
rescue:sos:{sosId}:status          → CREATED...
```

---

### 第 4 周：MQTT + EMQX（重点新技能）

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| MQTT 基础（QoS、Topic、TLS） | 读懂 MVP 附录 A Topic 规范 |
| Spring Integration MQTT 或 Eclipse Paho | 订阅 `rescue/iot/+/sos` |
| SOS 高优先级处理 | 写入 DB + 更新 Redis |

**联调步骤**：

1. MQTTX 连接本地 EMQX（`localhost:1883` 或 TLS 端口）
2. 向 `rescue/iot/{device_id}/sos` 发布测试 JSON
3. 后端消费 → 查 `sos_events` 表 → Redis 有实时状态

**Cursor 提示词示例**：

> 用 Spring Boot 集成 Eclipse Paho，订阅 rescue/iot/+/sos，解析 payload 写入 sos_events，并更新 Redis。参考 docs 中 MQTT 附录。

---

### 第 5 周：WebSocket + 通知骨架

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| Spring WebSocket / STOMP | `rescue_ws_server` 逻辑（可同进程） |
| 事件推送到运营端 | `docs/ws_events.md` |
| 异步通知占位 | `notify_worker` 发 Push 接口预留 |

**WebSocket 事件示例**：

```json
{
  "type": "SOS_CREATED",
  "sosId": "uuid",
  "lat": 37.7749,
  "lng": -122.4194,
  "status": "CREATED",
  "ts": "2026-06-02T10:00:00Z"
}
```

---

### 第 6 周：部署 + 端到端验收

| 学习目标 | 在本项目中的产出 |
|----------|------------------|
| Dockerfile 多阶段构建 | `rescue_platform_api/docker/Dockerfile` |
| 云服务器 SSH + compose 部署 | staging 环境可访问 API |
| P0 验收 | SOS 延迟 < 3s（见 MVP KPI） |

---

## 五、与 MVP 阶段任务对照

| MVP 阶段 | Spring Boot 对应任务 | 周次 |
|----------|----------------------|------|
| 第一阶段 | migrations、SOS API、mqtt 消费、Redis | 1–4 |
| 第二阶段 | 认证、设备/SIM API、WebSocket | 2–5 |
| 第三阶段 | 调度服务、工单 API | 6+（延伸） |

---

## 六、服务器部署（SSH）实操清单

### 6.1 Cursor 能帮你做什么

| 环节 | Cursor / OpenCode |
|------|-------------------|
| 写 `Dockerfile`、`docker-compose.prod.yml` | ✅ |
| 写 Nginx 反向代理、HTTPS 配置片段 | ✅ |
| 写 systemd 或 deploy 脚本 | ✅ |
| 解释 `docker logs`、Java 堆栈 | ✅ 贴日志给 Agent |
| 替你输入 SSH 密码 | ❌ 需你在终端执行 |

### 6.2 推荐部署流程（单人 MVP）

```bash
# 1. 本地验证
cd ~/rescue_platform/rescue_platform_infra
docker compose -f docker-compose.yml up -d

cd ~/rescue_platform/rescue_platform_api
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# 2. 云服务器（示例：Ubuntu 22.04）
ssh deploy@your-server-ip

# 3. 服务器上（首次）
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
mkdir -p ~/rescue && cd ~/rescue
# 上传 compose + .env（勿提交密钥到 Git）

# 4. 拉镜像或 docker compose build
docker compose -f docker-compose.prod.yml up -d

# 5. 健康检查
curl http://localhost:8080/actuator/health
```

### 6.3 `.env` 示例（生产勿进 Git）

```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/rescue_platform_db
SPRING_DATASOURCE_USERNAME=rescue
SPRING_DATASOURCE_PASSWORD=***
SPRING_DATA_REDIS_HOST=redis
MQTT_BROKER_URL=tcp://emqx:1883
JWT_SECRET=***
```

---

## 七、推荐学习资源

| 主题 | 资源 |
|------|------|
| Spring Boot 3 | [spring.io/guides](https://spring.io/guides) — Building REST services |
| PostgreSQL | 《PostgreSQL 即学即用》或官方 Tutorial |
| PostGIS | PostGIS 官方 doc（地图相关表后期加） |
| MQTT | EMQX 官方文档 + MQTTX 动手 |
| 安全 | Spring Security 6 JWT 官方 sample |
| Apollo | **MVP 可跳过**；需要时再学携程 Apollo 文档 |

---

## 八、何时考虑拆微服务 / 上 Apollo

| 信号 | 动作 |
|------|------|
| 单体启动 > 30s、团队 > 3 人 | 拆 `mqtt-worker`、`notify-worker` |
| 配置项 > 50 且多环境频繁改 | 评估 Apollo 或 Spring Cloud Config |
| SOS QPS 持续高 | mqtt-worker 水平扩展 + Redis 集群 |

**一人公司 MVP**：坚持单体 + Compose，避免过度设计。

---

## 九、Cursor 日常使用模板

```
# 新功能
在 rescue_platform_api 用 Spring Boot 3 实现 [功能]，
遵循现有包结构，补充 Flyway 脚本，并更新 docs/openapi.yaml。

# 排错
以下是启动报错和 application.yml，请分析原因并给出修复 diff。

# 部署
根据 rescue_platform_infra 的 compose，生成生产版 compose 和 API 的 Dockerfile。
```

---

## 十、检查清单（P0 后端可交付）

- [ ] `docker compose up` 后 PG、Redis、EMQX 均 healthy
- [ ] Flyway migrations 可重复执行
- [ ] POST `/api/v1/sos` 可创建并查询
- [ ] MQTTX 发 SOS → DB 有记录 → Redis 有状态
- [ ] WebSocket 运营端能收到 `SOS_CREATED`
- [ ] `docs/openapi.yaml` 已提交，CodeBuddy 可对接
- [ ] staging 服务器 SSH 部署成功，`/actuator/health` 返回 UP

---

*文档版本：v1.0 | 2026-06-02 | Spring Boot 路线*
