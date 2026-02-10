#!/usr/bin/env bash
set -e

# ==================================================
# Target defconfig
# ==================================================
DEFCONFIG="arch/arm64/configs/rodin_defconfig"

echo "⚙️ Adding KernelSU / SuSFS configuration to $DEFCONFIG"

# ==================================================
# KernelSU Base Configuration (ALWAYS ENABLED)
# ==================================================
cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# KernelSU Base Configuration
# ===============================================
CONFIG_KSU=y
CONFIG_KPM=y
CONFIG_KSU_MULTI_MANAGER_SUPPORT=y

# KernelSU dependency
CONFIG_KPROBES=y
CONFIG_KPROBE_EVENTS=y
EOF

# ==================================================
# Hook & SuSFS Logic
# ==================================================
if [ "$KSU" = "SukiSU" ]; then
    echo "🔧 Mode: SukiSU"

    if [ "$KSU_SUSFS" = "true" ]; then
        echo "🔧 SukiSU + SuSFS Enabled"
        cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# SuSFS Configuration (SukiSU)
# ===============================================
CONFIG_KSU_SUSFS=y
CONFIG_KSU_MANUAL_HOOK=n
EOF
    else
        echo "🔧 SukiSU without SuSFS"
        cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# SukiSU without SuSFS
# ===============================================
CONFIG_KSU_SUSFS=n
CONFIG_KSU_MANUAL_HOOK=n
EOF
    fi

elif [ "$KSU_SUSFS" = "true" ]; then
    echo "🔧 Mode: KernelSU Native + SuSFS (HYBRID SAFE)"

    cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# SuSFS Configuration (KernelSU Native)
# ===============================================
CONFIG_KSU_SUSFS=y
CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y
CONFIG_KSU_SUSFS_SUS_PATH=y
CONFIG_KSU_SUSFS_SUS_MOUNT=y
CONFIG_KSU_SUSFS_SUS_KSTAT_SPOOF_GENERIC=y
CONFIG_KSU_SUSFS_SUS_KSTAT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSTAT=y
CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n
CONFIG_KSU_SUSFS_TRY_UMOUNT=n
CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=n
CONFIG_KSU_SUSFS_SPOOF_UNAME=y
CONFIG_KSU_SUSFS_ENABLE_LOG=y
CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y
CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y
CONFIG_KSU_SUSFS_OPEN_REDIRECT=y

# Hybrid mode: NO legacy manual hook
CONFIG_KSU_MANUAL_HOOK=n
EOF

else
    echo "🔧 Mode: KernelSU Native (No SuSFS)"

    cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# KernelSU Native Only
# ===============================================
CONFIG_KSU_SUSFS=n
CONFIG_KSU_MANUAL_HOOK=n
EOF
fi

# ==================================================
# Universal Performance Tuning (Safe for GKI 6.6)
# ==================================================
echo "⚙️ Adding Universal Performance Tuning"

cat >> "$DEFCONFIG" <<'EOF'

# ===============================================
# Universal Performance Tuning
# ===============================================
CONFIG_HZ=250
CONFIG_HZ_250=y

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

CONFIG_SWAP=y
EOF

echo "✅ KernelSU / SuSFS defconfig configuration applied successfully"
