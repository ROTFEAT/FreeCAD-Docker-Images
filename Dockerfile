FROM ubuntu:22.04

# 安装 FreeCAD AppImage 所需运行依赖
RUN apt-get update && apt-get install -y \
    fuse xz-utils ca-certificates \
    && apt-get clean

# 拷贝解压后的 FreeCAD 内容
COPY squashfs-root/ /opt/freecad/

# 添加 FreeCAD 的 Python 路径到环境变量中
ENV PATH="/opt/freecad/usr/bin:$PATH"

# ✅ 使用 FreeCAD 自带的解释器进行验证
RUN /opt/freecad/usr/bin/python3 -c "import FreeCAD; print('✅ FreeCAD version:', FreeCAD.Version())"

# ✅ 设置默认命令为 FreeCAD 的解释器
CMD ["/opt/freecad/usr/bin/python3"]
