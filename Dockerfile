FROM ubuntu:22.04

# 安装 FreeCAD 所需运行依赖
RUN apt-get update && apt-get install -y \
    fuse xz-utils ca-certificates \
    && apt-get clean

# 拷贝已解压的 FreeCAD 内容
COPY squashfs-root/ /opt/freecad/

# 设置 PATH，使 FreeCAD 自带 Python 成为默认解释器
ENV PATH="/opt/freecad/usr/bin:$PATH"

# 验证环境（可选）
RUN python3 -c "import FreeCAD; print('✅ FreeCAD version:', FreeCAD.Version())"

CMD ["python3"]
