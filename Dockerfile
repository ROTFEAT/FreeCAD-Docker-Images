FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    fuse xz-utils ca-certificates \
    && apt-get clean

# 把 action 里解压好的内容复制进来
COPY squashfs-root/ /opt/freecad/

# 找到真正的 python3 可执行文件并做软链
RUN set -e; \
    pybin=$(find /opt/freecad -type f -name "python3*" -perm -111 | head -n1); \
    echo "→ detect FreeCAD python: $pybin"; \
    ln -sf "$pybin" /usr/local/bin/python3

# 让 PATH 里也能优先找到
ENV PATH="/opt/freecad/usr/bin:$PATH"

# （可选）验证
RUN python3 - <<'PY'
import FreeCAD
print("✅ FreeCAD version:", FreeCAD.Version())
PY

CMD ["python3"]
