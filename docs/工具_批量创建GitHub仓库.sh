#!/usr/bin/env bash
# 在 GitHub 账号 liuchao0739 下创建 rescue 平台相关仓库
# 使用前请先执行: gh auth login
# 然后运行: bash "工具_批量创建GitHub仓库.sh"

set -euo pipefail

OWNER="liuchao0739"
REPOS=(
  "rescue_mobile_suite:Flutter Monorepo - rescue_user_app + rescue_worker_app"
  "rescue_ops_web:运营平台 Web + rescue_dispatch_screen 调度大屏"
  "rescue_platform_api:后端 API + mqtt_worker + ws_server + notify_worker"
  "rescue_iot_firmware:物联网警示设备固件 - LTE-M / MQTT / OTA"
  "rescue_platform_infra:DevOps - K8s / Terraform / EMQX / 监控配置"
)

echo "==> 检查 GitHub CLI 登录状态..."
if ! gh auth status -h github.com &>/dev/null; then
  echo "未登录。请先执行: gh auth login"
  exit 1
fi

LOGIN=$(gh api user --jq .login)
echo "==> 当前账号: ${LOGIN}"
if [ "${LOGIN}" != "${OWNER}" ]; then
  echo "警告: 当前登录为 ${LOGIN}，预期为 ${OWNER}。继续将创建到 ${LOGIN} 账号下。"
  read -r -p "按 Enter 继续，Ctrl+C 取消..."
  OWNER="${LOGIN}"
fi

echo ""
echo "==> 开始创建 ${#REPOS[@]} 个仓库..."
echo ""

for entry in "${REPOS[@]}"; do
  name="${entry%%:*}"
  desc="${entry#*:}"

  if gh repo view "${OWNER}/${name}" &>/dev/null; then
    echo "[跳过] ${OWNER}/${name} 已存在"
    continue
  fi

  echo "[创建] ${OWNER}/${name}"
  gh repo create "${name}" \
    --public \
    --description "${desc}" \
    --add-readme \
    --confirm

  echo "       https://github.com/${OWNER}/${name}"
  echo ""
done

echo "==> 完成。仓库列表:"
gh repo list "${OWNER}" --limit 20 | grep rescue || true
