FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    fuse xz-utils ca-certificates && \
    apt-get clean

COPY squashfs-root/ /opt/freecad/

# 自动把 /opt/freecad/usr/bin/python3.* 里第一个匹配文件连成 python3 软链
RUN set -e; \
    pybin=$(ls /opt/freecad/usr/bin/python3* | head -n1); \
    ln -s "$pybin" /opt/freecad/usr/bin/python3

ENV PATH="/opt/freecad/usr/bin:$PATH"

# 验证 —— 现在可以用 python3 了
RUN python3 -c "import FreeCAD; print('✅ FreeCAD version:', FreeCAD.Version())"

CMD ["python3"]
