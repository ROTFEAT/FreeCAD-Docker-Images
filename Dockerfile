FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    fuse xz-utils ca-certificates && \
    apt-get clean

# 把 Action 步骤解包好的 FreeCAD 拷进来
COPY squashfs-root/ /opt/freecad/

# --- ① 侦测解释器并做软链 ---
RUN set -e; \
    # 1. 找真正的 python3* 可执行文件
    pybin=$(find /opt/freecad -type f -name "python3*" -perm -111 | head -n1 || true); \
    if [ -n "$pybin" ]; then \
        echo "✅ found embedded python: $pybin"; \
        ln -sf "$pybin" /usr/local/bin/python3; \
    else \
        # 2. 退化：把 FreeCADCmd 包装成 python3
        fcadcmd=$(find /opt/freecad -type f -name "FreeCADCmd" -perm -111 | head -n1); \
        echo "⚠️  python3 not found, fallback to FreeCADCmd: $fcadcmd"; \
        echo '#!/bin/sh'                             >  /usr/local/bin/python3; \
        echo "exec \"$fcadcmd\" \"\$@\""            >> /usr/local/bin/python3; \
        chmod +x /usr/local/bin/python3; \
    fi

# --- ② PATH 中依旧保留原 FreeCAD bin 方便直接调用 ---
ENV PATH="/opt/freecad/usr/bin:$PATH"

# --- ③ 构建阶段验证 ---
RUN python3 - <<'PY'
import sys, FreeCAD
print("FreeCAD   :", FreeCAD.Version())
print("Interpreter:", sys.executable)
PY

CMD ["python3"]
